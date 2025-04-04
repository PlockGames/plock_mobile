import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/services/auth_service.dart';
import 'package:plock_mobile/services/api_service.dart';

@GenerateMocks([AuthService, http.Client])
import 'api_service_unit_test.mocks.dart';

void main() {
  late ApiService apiService;
  late MockAuthService mockAuthService;
  late MockClient mockClient;

  setUp(() {
    mockAuthService = MockAuthService();
    mockClient = MockClient();
    apiService = ApiService(
        authService: mockAuthService,
        client: mockClient
    );
  });

  group('ApiService - Token Refresh', () {
    test('request with expired token attempts to refresh token', () async {
      // Préparation - Premier appel avec token expiré
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'expired_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Token expired"}',
        401,
      ));

      // Préparation - Refresh token réussi
      when(mockAuthService.refreshToken())
          .thenAnswer((_) async => true);

      // Préparation - Second appel avec nouveau token
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'new_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: captureAnyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Success", "data": {"key": "value"}}',
        200,
      ));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'Success');
      verify(mockAuthService.refreshToken()).called(1);
    });

    test('request with expired token and failed refresh returns auth error', () async {
      // Préparation - Token expiré
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'expired_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Token expired"}',
        401,
      ));

      // Préparation - Refresh token échoué
      when(mockAuthService.refreshToken())
          .thenAnswer((_) async => false);

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], false);
      expect(result['message'], contains('Authentication required'));
      verify(mockAuthService.refreshToken()).called(1);
    });
  });

  group('ApiService - Request with parameters', () {
    test('get request with query parameters works correctly', () async {
      // Préparation
      final params = {'page': '1', 'limit': '10', 'sort': 'name'};

      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      final expectedUri = Uri.parse('${ApiService.baseUrl}/test?page=1&limit=10&sort=name');

      when(mockClient.get(
        expectedUri,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Success", "data": []}',
        200,
      ));

      // Exécution
      final result = await apiService.get('/test', queryParams: params);

      // Vérification
      expect(result['success'], true);

      // Vérifie que l'URL contient les bons paramètres
      final verificationResult = verify(mockClient.get(
        captureAny,
        headers: anyNamed('headers'),
      ));

      final capturedUri = verificationResult.captured[0] as Uri;
      expect(capturedUri, expectedUri);
      expect(capturedUri.queryParameters['page'], '1');
      expect(capturedUri.queryParameters['limit'], '10');
      expect(capturedUri.queryParameters['sort'], 'name');
    });
  });

  group('ApiService - Content type handling', () {
    test('post request with custom content type works correctly', () async {
      // Préparation
      final data = {'name': 'Test', 'file': 'base64encodedstring'};
      const contentType = 'multipart/form-data';

      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.post(
        Uri.parse('${ApiService.baseUrl}/upload'),
        headers: captureAnyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "File uploaded", "data": {"id": "123"}}',
        201,
      ));

      // Exécution
      final result = await apiService.post('/upload', data, contentType: contentType);

      // Vérification
      expect(result['success'], true);
      expect(result['message'], 'File uploaded');

      // Vérifie les headers envoyés
      final capturedHeaders = verify(mockClient.post(
        any,
        headers: captureAnyNamed('headers'),
        body: anyNamed('body'),
      )).captured[0] as Map<String, String>;

      expect(capturedHeaders['Content-Type'], contentType);
    });
  });

  group('ApiService - Error handling', () {
    test('get request with malformed JSON response handles error properly', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{malformed json',
        200,
      ));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], false);
      expect(result['message'], contains('Error processing response'));
    });

    test('post request with server error returns proper error message', () async {
      // Préparation
      final data = {'name': 'Test'};

      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.post(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Internal server error"}',
        500,
      ));

      // Exécution
      final result = await apiService.post('/test', data);

      // Vérification
      expect(result['success'], false);
      expect(result['message'], 'Internal server error');
    });

    test('get request with array message format processes correctly', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/test'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": ["Multiple", "Error", "Messages"]}',
        400,
      ));

      // Exécution
      final result = await apiService.get('/test');

      // Vérification
      expect(result['success'], false);
      expect(result['message'], 'Multiple\nError\nMessages');
    });
  });

  group('ApiService - Request batching', () {
    test('batchRequests executes multiple requests and collects results', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/users'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Users fetched", "data": [{"id": 1}]}',
        200,
      ));

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/posts'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Posts fetched", "data": [{"id": 101}]}',
        200,
      ));

      // Exécution
      final results = await apiService.batchRequests([
            () => apiService.get('/users'),
            () => apiService.get('/posts'),
      ]);

      // Vérification
      expect(results.length, 2);
      expect(results[0]['success'], true);
      expect(results[0]['data'][0]['id'], 1);
      expect(results[1]['success'], true);
      expect(results[1]['data'][0]['id'], 101);
    });

    test('batchRequests handles failures in individual requests', () async {
      // Préparation
      when(mockAuthService.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/users'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Users fetched", "data": [{"id": 1}]}',
        200,
      ));

      when(mockClient.get(
        Uri.parse('${ApiService.baseUrl}/error'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"message": "Not found"}',
        404,
      ));

      // Exécution
      final results = await apiService.batchRequests([
            () => apiService.get('/users'),
            () => apiService.get('/error'),
      ]);

      // Vérification
      expect(results.length, 2);
      expect(results[0]['success'], true);
      expect(results[1]['success'], false);
      expect(results[1]['message'], 'Not found');
    });
  });
}