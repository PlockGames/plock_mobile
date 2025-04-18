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

  group('AuthService - completeSignup', () {

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