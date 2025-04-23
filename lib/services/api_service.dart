import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import 'http_client_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String baseUrl =
      dotenv.env['API_URL'] ?? 'http://localhost:3000/api';
  final AuthService _authService;
  final HttpClientService _httpClient;

  ApiService({
    AuthService? authService,
    http.Client? client,
  })  : _authService = authService ?? AuthService(),
        _httpClient = HttpClientService(
          authService: authService,
          client: client,
        );

  // GET request with authentication token
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final token = await _authService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  // POST request with authentication token
  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _httpClient.post(endpoint, data);
      return _processResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  // PUT request with authentication token
  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _httpClient.put(endpoint, data);
      return _processResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  // DELETE request with authentication token
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _httpClient.delete(endpoint);
      return _processResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  // PATCH request with authentication token
  Future<Map<String, dynamic>> patch(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _httpClient.patch(endpoint, data);
      return _processResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  // Méthode pour envoyer des fichiers
  Future<Map<String, dynamic>> uploadMedia(
      String endpoint, Uint8List data) async {
    try {
      final token = await _authService.getAccessToken();
      http.MultipartFile file = http.MultipartFile.fromBytes('images', data,
          filename: "image.png", contentType: http.MediaType("image", "png"));

      final body =
          http.MultipartRequest("POST", Uri.parse('$baseUrl$endpoint'));
      body.files.add(file);

      // Create headers with Content-Type first
      final headers = {
        "Content-Type": "multipart/form-data",
      };

      // Only add the Authorization header if token exists
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      body.headers.addAll(headers);

      final res = await body.send();
      final httpRes = await http.Response.fromStream(res);
      print(httpRes.body);
      return _processResponse(httpRes);
    } catch (e) {
      return {'success': false, 'message': 'Error: $e', 'data': null};
    }
  }

  // Method to process HTTP responses
  Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Success',
          'data': responseData['data']
        };
      } else {
        var message = responseData['message'];
        if (message is List) {
          message = message.join('\n');
        }

        return {
          'success': false,
          'message':
              message ?? 'Request failed with status: ${response.statusCode}',
          'data': null
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error processing response: $e',
        'data': null
      };
    }
  }
}
