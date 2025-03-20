import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plock_mobile/services/auth_service.dart';

// Génère les mocks
@GenerateMocks([http.Client, FlutterSecureStorage])
import 'auth_service_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockClient mockClient;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockClient = MockClient();
    mockSecureStorage = MockFlutterSecureStorage();

    // Injection des mocks (nécessite de modifier l'AuthService pour accepter ces dépendances)
    authService = AuthService(
        client: mockClient,
        storage: mockSecureStorage
    );
  });

  group('AuthService - signup', () {
    test('signup success returns success true', () async {
      // Préparation
      final signupData = <String, String>{
        'email': 'test@example.com',
        'password': 'password123',
        'username': 'testuser',
        'birthDate': '1990-01-01',
      };

      // Mock de la réponse HTTP
      when(mockClient.post(
        Uri.parse(AuthService.signupUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"data": {"accessToken": "fake_token", "refreshToken": "fake_refresh_token"}}',
        201,
      ));

      // Exécution
      final result = await authService.signup(signupData);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Signup successful');

      // Vérification du stockage des tokens
      verify(mockSecureStorage.write(key: 'accessToken', value: 'fake_token')).called(1);
      verify(mockSecureStorage.write(key: 'refreshToken', value: 'fake_refresh_token')).called(1);
    });

    test('signup failure returns success false', () async {
      // Préparation
      final signupData = <String, String>{
        'email': 'test@example.com',
        'password': 'password123',
        'username': 'testuser',
        'birthDate': '1990-01-01',
      };

      // Mock de la réponse HTTP
      when(mockClient.post(
        Uri.parse(AuthService.signupUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Email already exists"}',
        400,
      ));

      // Exécution
      final result = await authService.signup(signupData);

      // Vérification
      expect(result['success'], false);
      expect(result['message'], 'Email already exists');

      // Vérification qu'aucun token n'est stocké
      verifyNever(mockSecureStorage.write(key: 'accessToken', value: anyNamed('value')));
      verifyNever(mockSecureStorage.write(key: 'refreshToken', value: anyNamed('value')));
    });

    test('signup handles network timeout', () async {
      // Préparation
      final signupData = <String, String>{
        'email': 'test@example.com',
        'password': 'password123',
        'username': 'testuser',
        'birthDate': '1990-01-01',
      };

      // Mock d'une exception timeout
      when(mockClient.post(
        Uri.parse(AuthService.signupUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenThrow(Exception('La connexion au serveur a expiré'));

      // Exécution
      final result = await authService.signup(signupData);

      // Vérification
      expect(result['success'], false);
      expect(result['message'], contains('Error: Exception: La connexion au serveur a expiré'));
    });
  });

  group('AuthService - completeSignup', () {
    test('completeSignup success returns success true', () async {
      // Préparation
      final completeData = <String, String>{
        'firstName': 'John',
        'lastName': 'Doe',
        'phoneNumber': '1234567890',
        'birthDate': '1990-01-01',
      };

      // Mock getAccessToken pour retourner un token
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'fake_token');

      // Mock de la réponse HTTP
      when(mockClient.post(
        Uri.parse(AuthService.completeSignupUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"data": {"accessToken": "new_token", "refreshToken": "new_refresh_token"}}',
        201,
      ));

      // Exécution
      final result = await authService.completeSignup(completeData);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Registration completed successfully');

      // Vérification du stockage des nouveaux tokens
      verify(mockSecureStorage.write(key: 'accessToken', value: 'new_token')).called(1);
      verify(mockSecureStorage.write(key: 'refreshToken', value: 'new_refresh_token')).called(1);
    });

    test('completeSignup with no access token returns failure', () async {
      // Préparation
      final completeData = <String, String>{
        'firstName': 'John',
        'lastName': 'Doe',
        'phoneNumber': '1234567890',
        'birthDate': '1990-01-01',
      };

      // Mock getAccessToken pour retourner null
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => null);

      // Exécution
      final result = await authService.completeSignup(completeData);

      // Vérification
      expect(result['success'], false);
      expect(result['message'], 'No access token available');
    });

    test('completeSignup handles JSON decode error', () async {
      // Préparation
      final completeData = <String, String>{
        'firstName': 'John',
        'lastName': 'Doe',
        'phoneNumber': '1234567890',
        'birthDate': '1990-01-01',
      };

      // Mock getAccessToken pour retourner un token
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'fake_token');

      // Mock de la réponse HTTP avec un JSON invalide
      when(mockClient.post(
        Uri.parse(AuthService.completeSignupUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{invalidJson}',
        201,
      ));

      // Exécution
      final result = await authService.completeSignup(completeData);

      // Vérification
      expect(result['success'], false);
      expect(result['message'], contains('Erreur lors du décodage de la réponse'));
    });
  });

  group('AuthService - token management', () {
    test('getAccessToken returns stored token', () async {
      // Mock de la réponse du secure storage
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'stored_token');

      // Exécution
      final token = await authService.getAccessToken();

      // Vérification
      expect(token, 'stored_token');
    });

    test('isLoggedIn returns true when access token exists', () async {
      // Mock de la réponse du secure storage
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => 'stored_token');

      // Exécution
      final isLogged = await authService.isLoggedIn();

      // Vérification
      expect(isLogged, true);
    });

    test('isLoggedIn returns false when access token is null', () async {
      // Mock de la réponse du secure storage
      when(mockSecureStorage.read(key: 'accessToken'))
          .thenAnswer((_) async => null);

      // Exécution
      final isLogged = await authService.isLoggedIn();

      // Vérification
      expect(isLogged, false);
    });

    test('logout deletes stored tokens', () async {
      // Exécution
      await authService.logout();

      // Vérification que les tokens sont supprimés
      verify(mockSecureStorage.delete(key: 'accessToken')).called(1);
      verify(mockSecureStorage.delete(key: 'refreshToken')).called(1);
    });
  });
}