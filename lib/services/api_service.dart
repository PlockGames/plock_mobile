import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'dart:convert';
import 'auth_service.dart';

class ApiService {
  static String baseUrl = dotenv.env['API_URL']!;
  final AuthService _authService;
  final http.Client _client;

  ApiService({
    AuthService? authService,
    http.Client? client,
  }) :
        _authService = authService ?? AuthService(),
        _client = client ?? http.Client();

  // GET request avec token d'authentification
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
      return {
        'success': false,
        'message': 'Error: $e',
        'data': null
      };
    }
  }

  // POST request avec token d'authentification
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _authService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'data': null
      };
    }
  }

  // PUT request avec token d'authentification
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _authService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await _client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'data': null
      };
    }
  }

  // DELETE request avec token d'authentification
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final token = await _authService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'data': null
      };
    }
  }

  // PATCH request avec token d'authentification
  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _authService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await _client.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'data': null
      };
    }
  }

  // Méthode pour envoyer des fichiers
  Future<Map<String, dynamic>> uploadMedia(String endpoint, Uint8List data) async {
    try {
      final token = await _authService.getAccessToken();
      http.MultipartFile file = http.MultipartFile.fromBytes('images', data, filename: "image.png", contentType: http.MediaType("image", "png"));

      final body = http.MultipartRequest("POST", Uri.parse('$baseUrl$endpoint'));
      body.files.add(file);
      body.headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      });
      final res = await body.send();
      final httpRes = await http.Response.fromStream(res);
      print(httpRes.body);
      return _processResponse(httpRes);

    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
        'data': null
      };
    }
  }

  // Méthode pour traiter les réponses HTTP
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
          'message': message ?? 'Request failed with status: ${response.statusCode}',
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
