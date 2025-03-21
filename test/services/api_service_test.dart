import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/services/auth_service.dart';
import 'package:plock_mobile/services/api_service.dart';

// Génération des mocks
@GenerateMocks([AuthService, http.Client])
import 'api_service_test.mocks.dart';

void main() {
  late ApiService apiService;
  late MockAuthService mockAuthService;
  late MockClient mockClient;

  setUp(() {
    mockAuthService = MockAuthService();
    mockClient = MockClient();

    // Injection des mocks (nécessite modification de ApiService)
    apiService = ApiService(
        authService: mockAuthService,
        client: mockClient
    );
  });

  group('ApiService - GET requests', () {
    test('get request with token returns success response', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Success", "data": {"key": "value"}}',
        200,
      ));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Success');
      expect(result['data']['key'], 'value');

      // Vérification de l'en-tête Authorization
      final capturedHeaders = verify(mockClient.get(
        any,
        headers: captureAnyNamed('headers'),
      )).captured[0] as Map<String, String>;

      expect(capturedHeaders['Authorization'], 'Bearer fake_token');
    });

    test('get request without token still works', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => null);

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Public data", "data": {"type": "public"}}',
        200,
      ));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Public data');

      // Vérification de l'absence d'en-tête Authorization
      final capturedHeaders = verify(mockClient.get(
        any,
        headers: captureAnyNamed('headers'),
      )).captured[0] as Map<String, String>;

      expect(capturedHeaders.containsKey('Authorization'), false);
    });

    test('get request with error response returns failure', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Not found"}',
        404,
      ));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], false);
      expect(result['message'], 'Not found');
      expect(result['data'], null);
    });

    test('get request with network error returns failure', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenThrow(Exception('Network error'));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], false);
      expect(result['message'], contains('Error: Exception: Network error'));
      expect(result['data'], null);
    });
  });

  group('ApiService - POST requests', () {
    test('post request with token returns success response', () async {
      // Préparation
      final data = {'name': 'Test', 'value': 123};

      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.post(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Created", "data": {"id": 1}}',
        201,
      ));

      // Exécution
      final result = await apiService.post('/test', data);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Created');
      expect(result['data']['id'], 1);
    });

    test('post request with error response returns failure', () async {
      // Préparation
      final data = {'name': 'Test', 'value': 123};

      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.post(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": ["Validation error 1", "Validation error 2"]}',
        400,
      ));

      // Exécution
      final result = await apiService.post('/test', data);

      // Vérification
      expect(result['success'], false);
      expect(result['message'], 'Validation error 1\nValidation error 2');
      expect(result['data'], null);
    });
  });

  group('ApiService - PUT requests', () {
    test('put request with token returns success response', () async {
      // Préparation
      final data = {'id': 1, 'name': 'Updated Test'};

      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.put(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Updated", "data": {"id": 1, "name": "Updated Test"}}',
        200,
      ));

      // Exécution
      final result = await apiService.put('/test', data);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Updated');
      expect(result['data']['name'], 'Updated Test');
    });
  });

  group('ApiService - DELETE requests', () {
    test('delete request with token returns success response', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.delete(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Deleted successfully", "data": null}',
        200,
      ));

      // Exécution
      final result = await apiService.delete('/test');

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Deleted successfully');
    });
  });

  group('ApiService - PATCH requests', () {
    test('patch request with token returns success response', () async {
      // Préparation
      final data = {'name': 'Partially Updated'};

      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.patch(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Partially updated", "data": {"id": 1, "name": "Partially Updated"}}',
        200,
      ));

      // Exécution
      final result = await apiService.patch('/test', data);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Partially updated');
      expect(result['data']['name'], 'Partially Updated');
    });
  });

  group('ApiService - Response processing', () {
    test('_processResponse handles JSON parse error', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        'Invalid JSON response',
        200,
      ));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], false);
      expect(result['message'], contains('Error processing response'));
      expect(result['data'], null);
    });
  });
}