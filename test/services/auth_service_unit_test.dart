import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plock_mobile/services/auth_service.dart';

// Génère les mocks
@GenerateMocks([http.Client, FlutterSecureStorage])
import 'auth_service_unit_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockClient mockClient;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockClient = MockClient();
    mockSecureStorage = MockFlutterSecureStorage();
    authService = AuthService(
        client: mockClient,
        storage: mockSecureStorage
    );
  });

  group('AuthService - Token Refresh', () {
    test('refreshToken with valid refresh token updates both tokens', () async {
      // Préparation
      when(mockSecureStorage.read(key: 'refreshToken'))
          .thenAnswer((_) async => 'valid_refresh_token');

      when(mockClient.post(
        Uri.parse(AuthService.refreshTokenUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"data": {"accessToken": "new_access_token", "refreshToken": "new_refresh_token"}}',
        200,
      ));

      // Exécution
      final result = await authService.refreshToken();

      // Vérification
      expect(result, true);
      verify(mockSecureStorage.write(key: 'accessToken', value: 'new_access_token')).called(1);
      verify(mockSecureStorage.write(key: 'refreshToken', value: 'new_refresh_token')).called(1);
    });

    test('refreshToken with invalid refresh token returns false', () async {
      // Préparation
      when(mockSecureStorage.read(key: 'refreshToken'))
          .thenAnswer((_) async => 'invalid_refresh_token');

      when(mockClient.post(
        Uri.parse(AuthService.refreshTokenUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Invalid refresh token"}',
        401,
      ));

      // Exécution
      final result = await authService.refreshToken();

      // Vérification
      expect(result, false);
      verifyNever(mockSecureStorage.write(key: 'accessToken', value: anyNamed('value')));
      verifyNever(mockSecureStorage.write(key: 'refreshToken', value: anyNamed('value')));
    });

    test('refreshToken with no stored refresh token returns false', () async {
      // Préparation
      when(mockSecureStorage.read(key: 'refreshToken'))
          .thenAnswer((_) async => null);

      // Exécution
      final result = await authService.refreshToken();

      // Vérification
      expect(result, false);
      verifyNever(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')));
    });
  });

  group('AuthService - Login', () {
    test('login with valid credentials returns success', () async {
      // Préparation
      final loginData = {
        'email': 'test@example.com',
        'password': 'password123',
      };

      when(mockClient.post(
        Uri.parse(AuthService.loginUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"data": {"accessToken": "login_token", "refreshToken": "login_refresh_token"}}',
        200,
      ));

      // Exécution
      final result = await authService.login(loginData);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Login successful');
      verify(mockSecureStorage.write(key: 'accessToken', value: 'login_token')).called(1);
      verify(mockSecureStorage.write(key: 'refreshToken', value: 'login_refresh_token')).called(1);
    });

    test('login with invalid credentials returns failure', () async {
      // Préparation
      final loginData = {
        'email': 'test@example.com',
        'password': 'wrong_password',
      };

      when(mockClient.post(
        Uri.parse(AuthService.loginUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Invalid email or password"}',
        401,
      ));

      // Exécution
      final result = await authService.login(loginData);

      // Vérification
      expect(result['success'], false);
      expect(result['message'], 'Invalid email or password');
      verifyNever(mockSecureStorage.write(key: 'accessToken', value: anyNamed('value')));
      verifyNever(mockSecureStorage.write(key: 'refreshToken', value: anyNamed('value')));
    });
  });

  group('AuthService - Password Reset', () {
    test('requestPasswordReset sends email with success', () async {
      // Préparation
      final email = 'test@example.com';

      when(mockClient.post(
        Uri.parse(AuthService.requestPasswordResetUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Password reset email sent"}',
        200,
      ));

      // Exécution
      final result = await authService.requestPasswordReset(email);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Password reset email sent');
    });

    test('confirmPasswordReset with valid token returns success', () async {
      // Préparation
      final resetData = {
        'token': 'valid_reset_token',
        'password': 'new_password123',
      };

      when(mockClient.post(
        Uri.parse(AuthService.confirmPasswordResetUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Password reset successfully"}',
        200,
      ));

      // Exécution
      final result = await authService.confirmPasswordReset(resetData);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Password reset successfully');
    });
  });

  group('AuthService - Token validation', () {
    test('validateToken with valid token returns true', () async {
      // Préparation
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'valid_token');

      when(mockClient.get(
        Uri.parse(AuthService.validateTokenUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"data": {"valid": true}}',
        200,
      ));

      // Exécution
      final result = await authService.validateToken();

      // Vérification
      expect(result, true);
    });

    test('validateToken with invalid token returns false', () async {
      // Préparation
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'invalid_token');

      when(mockClient.get(
        Uri.parse(AuthService.validateTokenUrl),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Invalid token"}',
        401,
      ));

      // Exécution
      final result = await authService.validateToken();

      // Vérification
      expect(result, false);
    });

    test('validateToken with network error returns false', () async {
      // Préparation
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'valid_token');

      when(mockClient.get(
        Uri.parse(AuthService.validateTokenUrl),
        headers: anyNamed('headers'),
      )).thenThrow(Exception('Network error'));

      // Exécution
      final result = await authService.validateToken();

      // Vérification
      expect(result, false);
    });
  });
}