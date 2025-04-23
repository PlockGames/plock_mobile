import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_service.dart';

/// Centralized service to perform HTTP requests with authentication token
class HttpClientService {
  final AuthService _authService;
  final http.Client _client;
  static final String baseUrl =
      dotenv.env['API_URL'] ?? 'http://localhost:3000/api';

  HttpClientService({
    AuthService? authService,
    http.Client? client,
  })  : _authService = authService ?? AuthService(),
        _client = client ?? http.Client();

  /// Gets the headers with the authentication token
  Future<Map<String, String>> _getAuthHeaders(
      {Map<String, String>? additionalHeaders}) async {
    final token = await _authService.getAccessToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// GET request with authentication
  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) async {
    final authHeaders = await _getAuthHeaders(additionalHeaders: headers);
    print('GET request to $baseUrl$endpoint with headers: $authHeaders');
    return _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: authHeaders,
    );
  }

  /// POST request with authentication
  Future<http.Response> post(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    final authHeaders = await _getAuthHeaders(additionalHeaders: headers);
    print('POST request to $baseUrl$endpoint with headers: $authHeaders');

    String encodedBody;
    if (body is String) {
      encodedBody = body;
    } else if (body != null) {
      encodedBody = json.encode(body);
    } else {
      encodedBody = '';
    }

    return _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: authHeaders,
      body: encodedBody,
    );
  }

  /// PUT request with authentication
  Future<http.Response> put(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    final authHeaders = await _getAuthHeaders(additionalHeaders: headers);
    print('PUT request to $baseUrl$endpoint with headers: $authHeaders');

    String encodedBody;
    if (body is String) {
      encodedBody = body;
    } else if (body != null) {
      encodedBody = json.encode(body);
    } else {
      encodedBody = '';
    }

    return _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: authHeaders,
      body: encodedBody,
    );
  }

  /// DELETE request with authentication
  Future<http.Response> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final authHeaders = await _getAuthHeaders(additionalHeaders: headers);
    print('DELETE request to $baseUrl$endpoint with headers: $authHeaders');
    return _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: authHeaders,
    );
  }

  /// PATCH request with authentication
  Future<http.Response> patch(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    final authHeaders = await _getAuthHeaders(additionalHeaders: headers);
    print('PATCH request to $baseUrl$endpoint with headers: $authHeaders');

    String encodedBody;
    if (body is String) {
      encodedBody = body;
    } else if (body != null) {
      encodedBody = json.encode(body);
    } else {
      encodedBody = '';
    }

    return _client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: authHeaders,
      body: encodedBody,
    );
  }

  /// Multipart request with authentication (for file uploads)
  Future<http.Response> multipartRequest(String endpoint,
      Map<String, dynamic> fields, Map<String, List<int>> files,
      {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final authHeaders = await _getAuthHeaders(additionalHeaders: headers);

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(authHeaders);

    // Add fields
    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add files
    files.forEach((key, value) async {
      request.files.add(http.MultipartFile.fromBytes(
        key,
        value,
        filename: key,
      ));
    });

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  /// For requests to external URLs (without baseUrl)
  Future<http.Response> getExternal(String url,
      {Map<String, String>? headers}) async {
    final authHeaders = await _getAuthHeaders(additionalHeaders: headers);
    return _client.get(
      Uri.parse(url),
      headers: authHeaders,
    );
  }
}
