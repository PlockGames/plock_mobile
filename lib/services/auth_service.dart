import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String baseUrl =
      dotenv.env['API_URL'] ?? 'http://localhost:3000/api';

  static final String loginUrl = "$baseUrl/auth/login";
  static final String signupUrl = "$baseUrl/auth/signup";
  static final String completeSignupUrl = "$baseUrl/auth/signup/complete";

  final FlutterSecureStorage _storage;
  final http.Client _client;

  AuthService({
    FlutterSecureStorage? storage,
    http.Client? client,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _client = client ?? http.Client();

  // Simple log function
  void _log(String message) {
    print("AuthService: $message");
  }

  // Method to store tokens
  Future<void> _storeTokens(String accessToken, String? refreshToken) async {
    try {
      await _storage.write(key: 'accessToken', value: accessToken);
      if (refreshToken != null) {
        await _storage.write(key: 'refreshToken', value: refreshToken);
      }
      _log('Tokens successfully stored');
    } catch (e) {
      _log('Error storing tokens: $e');
      throw Exception('Error storing tokens: $e');
    }
  }

  // Method to retrieve the access token
  Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      if (token == null) {
        _log('No access token found');
      } else {
        _log(
            'Access token retrieved: ${token.substring(0, min(10, token.length))}...');
      }
      return token;
    } catch (e) {
      _log('Error retrieving access token: $e');
      return null;
    }
  }

  // Utility function for min
  int min(int a, int b) {
    return a < b ? a : b;
  }

  // Method to retrieve the refresh token
  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: 'refreshToken');
      if (token == null) {
        _log('No refresh token found');
      } else {
        _log('Refresh token retrieved');
      }
      return token;
    } catch (e) {
      _log('Error retrieving refresh token: $e');
      return null;
    }
  }

  // Method to check if the user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await getAccessToken();
      final isLogged = token != null && token.isNotEmpty;
      _log('Login check: ${isLogged ? 'Logged in' : 'Not logged in'}');
      return isLogged;
    } catch (e) {
      _log('Error checking login status: $e');
      return false;
    }
  }

  // Method to log out
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      _log('Logout successful');
    } catch (e) {
      _log('Error during logout: $e');
      throw Exception('Error during logout: $e');
    }
  }

  // Method to log in
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      _log('Attempting login for: $email');

      final response = await _client.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      _log('Login server response - Status: ${response.statusCode}');
      _log('Login server response - Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        final accessToken = responseData['data']['accessToken'];
        final refreshToken = responseData['data']['refreshToken'];

        await _storeTokens(accessToken, refreshToken);
        _log('Login successful for: $email');

        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData['data']
        };
      } else {
        _log('Login failed for: $email - Reason: ${responseData['message']}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      _log('Exception during login: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Method to sign up (step 1)
  Future<Map<String, dynamic>> signup(Map<String, String> signupData) async {
    try {
      _log('Signup attempt - Step 1 with data: ${signupData.toString()}');

      // Add a delay to ensure the request is properly sent
      await Future.delayed(Duration(milliseconds: 500));

      final response = await _client
          .post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(signupData),
      )
          .timeout(Duration(seconds: 15), onTimeout: () {
        _log('TIMEOUT: Signup request timed out');
        throw Exception('Server connection timed out');
      });

      _log('Signup step 1 server response - Status: ${response.statusCode}');
      _log('Signup step 1 server response - Body: ${response.body}');

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        _log('Error decoding JSON response: $e');
        _log('Raw response content: ${response.body}');
        return {
          'success': false,
          'message': 'Error decoding response: ${response.body}',
        };
      }

      if (response.statusCode == 201) {
        if (responseData['data'] == null ||
            responseData['data']['accessToken'] == null) {
          _log('Signup successful but tokens missing in response');
          return {
            'success': false,
            'message': 'Signup successful but server response error',
          };
        }

        final accessToken = responseData['data']['accessToken'];
        final refreshToken = responseData['data']['refreshToken'];

        await _storeTokens(accessToken, refreshToken);
        _log('Signup step 1 successful');

        return {
          'success': true,
          'message': 'Signup successful',
          'data': responseData['data']
        };
      } else {
        var message = responseData['message'];
        if (message is List) {
          message = message.join('\n');
        }

        _log('Signup step 1 failed - Reason: $message');
        return {
          'success': false,
          'message': message ?? 'Signup failed',
        };
      }
    } catch (e) {
      _log('Exception during signup step 1: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Method to complete signup (step 2)
  Future<Map<String, dynamic>> completeSignup(
      Map<String, String> completeData) async {
    try {
      _log('Signup attempt - Step 2 with data: ${completeData.toString()}');

      final accessToken = await getAccessToken();

      if (accessToken == null) {
        _log('Signup step 2 failed - No access token available');
        return {
          'success': false,
          'message': 'No access token available',
        };
      }

      final response = await _client
          .post(
        Uri.parse(completeSignupUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(completeData),
      )
          .timeout(Duration(seconds: 15), onTimeout: () {
        _log('TIMEOUT: Signup completion request timed out');
        throw Exception('Server connection timed out');
      });

      _log('Signup step 2 server response - Status: ${response.statusCode}');
      _log('Signup step 2 server response - Body: ${response.body}');

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        _log('Error decoding JSON response: $e');
        _log('Raw response content: ${response.body}');
        return {
          'success': false,
          'message': 'Error decoding response: ${response.body}',
        };
      }

      if (response.statusCode == 201) {
        // Check if there are new tokens to store
        if (responseData['data'] != null &&
            responseData['data']['accessToken'] != null) {
          final newAccessToken = responseData['data']['accessToken'];
          final newRefreshToken = responseData['data']['refreshToken'];

          await _storeTokens(newAccessToken, newRefreshToken);
        }

        _log('Signup step 2 successful');
        return {
          'success': true,
          'message': 'Registration completed successfully',
          'data': responseData['data']
        };
      } else {
        var message = responseData['message'];
        if (message is List) {
          message = message.join('\n');
        }

        _log('Signup step 2 failed - Reason: $message');
        return {
          'success': false,
          'message': message ?? 'Failed to complete registration',
        };
      }
    } catch (e) {
      _log('Exception during signup step 2: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Method to add the authentication token to request headers
  Future<Map<String, String>> getAuthHeaders(
      [Map<String, String>? headers]) async {
    try {
      final accessToken = await getAccessToken();
      final Map<String, String> authHeaders =
          headers ?? {'Content-Type': 'application/json'};

      if (accessToken != null) {
        authHeaders['Authorization'] = 'Bearer $accessToken';
      }

      return authHeaders;
    } catch (e) {
      _log('Error retrieving auth headers: $e');
      return {'Content-Type': 'application/json'};
    }
  }
}
