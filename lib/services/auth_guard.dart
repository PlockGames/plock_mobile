import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_service.dart';

class AuthGuard {
  final AuthService _authService;
  final FlutterSecureStorage _storage;

  AuthGuard({
    AuthService? authService,
    FlutterSecureStorage? storage,
  })  : _authService = authService ?? AuthService(),
        _storage = storage ?? const FlutterSecureStorage();

  /// Checks if a route is exempt from protection
  bool isPublicRoute(String routeName) {
    final publicRoutes = ['/login', '/register'];
    return publicRoutes.contains(routeName);
  }

  /// Validates a JWT token using the secret from .env
  Future<bool> validateToken(String? token) async {
    if (token == null || token.isEmpty) {
      print('Empty token - Authentication failed');
      return false;
    }

    try {
      // Split the token into its three parts: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Invalid token format');
        return false;
      }

      // Decode the payload to extract information
      final payload = json
          .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

      // Check if the token has expired
      if (payload['exp'] != null) {
        final expDate =
            DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
        final now = DateTime.now();

        // Adding debug information for expiration check
        print('Token expiration date: ${expDate.toString()}');
        print('Current date: ${now.toString()}');
        print('Difference in seconds: ${expDate.difference(now).inSeconds}');

        // Fix the expiration check logic
        // Consider the token valid if expDate is equal to or later than now
        if (expDate.isBefore(now)) {
          print('Expired token: ${expDate.toString()}');
          return false;
        } else {
          print('Token still valid - Expires on: ${expDate.toString()}');
        }
      }

      // In a full production environment, we should verify the JWT signature
      // using the JWT_SECRET from the .env file
      final jwtSecret = dotenv.env['JWT_SECRET'];
      if (jwtSecret != null && jwtSecret.isNotEmpty) {
        // Recreate the signature to compare it with the one received
        final signaturePart = parts[2];
        final signatureBase = '${parts[0]}.${parts[1]}';

        // Get secret key to verify signature
        final key = utf8.encode(jwtSecret);
        final hmacSha256 = Hmac(sha256, key);
        final digest = hmacSha256.convert(utf8.encode(signatureBase));
        final calculatedSignature = base64Url.encode(digest.bytes);

        // Compare signatures (may require additional normalization depending on server implementation)
        if (base64Url.normalize(signaturePart) !=
            base64Url.normalize(calculatedSignature)) {
          print('Invalid token signature');
          return false;
        }
      }

      print('Token successfully validated');
      return true;
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  /// Checks if the user is authorized to access a route
  Future<bool> canActivate(String routeName) async {
    // If the route is public, allow access without verification
    if (isPublicRoute(routeName)) {
      return true;
    }

    // Get the access token
    final token = await _authService.getAccessToken();

    // Validate the token
    final isValid = await validateToken(token);
    print('Route: $routeName - Access ${isValid ? "granted" : "denied"}');
    return isValid;
  }

  /// Handles redirection based on authentication state
  Future<String?> handleNavigation(String currentRoute) async {
    // Explicitly handle the root route
    if (currentRoute == '/' || currentRoute.isEmpty) {
      final isAuthenticated = await _authService.isLoggedIn();
      final tokenIsValid = isAuthenticated
          ? await validateToken(await _authService.getAccessToken())
          : false;

      print(
          'Root route detected - User authenticated: $isAuthenticated, Valid token: $tokenIsValid');
      return isAuthenticated && tokenIsValid ? '/home' : '/login';
    }

    final isAuthenticated = await _authService.isLoggedIn();
    final tokenIsValid = isAuthenticated
        ? await validateToken(await _authService.getAccessToken())
        : false;

    print(
        'Authentication state - User logged in: $isAuthenticated, Valid token: $tokenIsValid');

    // If navigating to a public route while authenticated (with valid token), redirect to home
    if (isPublicRoute(currentRoute) && isAuthenticated && tokenIsValid) {
      print(
          'User already authenticated trying to access $currentRoute - Redirecting to /home');
      return '/home';
    }

    // If navigating to a protected route without being authenticated, redirect to login
    if (!isPublicRoute(currentRoute) && (!isAuthenticated || !tokenIsValid)) {
      print(
          'Unauthenticated user trying to access $currentRoute - Redirecting to /login');
      return '/login';
    }

    // In any other case, allow original navigation
    print('Navigation allowed to $currentRoute');
    return null;
  }
}
