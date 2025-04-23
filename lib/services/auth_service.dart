import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static String baseUrl = "${dotenv.env['API_URL']!}/auth";
  static String loginUrl = "$baseUrl/login";
  static String signupUrl = "$baseUrl/signup";
  static String completeSignupUrl = "$baseUrl/signup/complete";

  final FlutterSecureStorage _storage;
  final http.Client _client;

  AuthService({
    FlutterSecureStorage? storage,
    http.Client? client,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _client = client ?? http.Client();

  // Fonction de log simple
  void _log(String message) {
    print("AuthService: $message");
  }

  // Méthode pour stocker les tokens
  Future<void> _storeTokens(String accessToken, String? refreshToken) async {
    try {
      await _storage.write(key: 'accessToken', value: accessToken);
      if (refreshToken != null) {
        await _storage.write(key: 'refreshToken', value: refreshToken);
      }
      _log('Tokens stockés avec succès');
    } catch (e) {
      _log('Erreur lors du stockage des tokens: $e');
      throw Exception('Erreur lors du stockage des tokens: $e');
    }
  }

  // Méthode pour récupérer l'access token
  Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: 'accessToken');
      if (token == null) {
        _log('Aucun access token trouvé');
      } else {
        _log(
            'Access token récupéré: ${token.substring(0, min(10, token.length))}...');
      }
      return token;
    } catch (e) {
      _log('Erreur lors de la récupération de l\'access token: $e');
      return null;
    }
  }

  // Fonction utilitaire pour min
  int min(int a, int b) {
    return a < b ? a : b;
  }

  // Méthode pour récupérer le refresh token
  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: 'refreshToken');
      if (token == null) {
        _log('Aucun refresh token trouvé');
      } else {
        _log('Refresh token récupéré');
      }
      return token;
    } catch (e) {
      _log('Erreur lors de la récupération du refresh token: $e');
      return null;
    }
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    try {
      final token = await getAccessToken();
      if (token == null || token.isEmpty) {
        _log('Vérification de connexion: Non connecté (token absent)');
        return false;
      }

      // Vérifier la validité du token
      final isValid = await isTokenValid(token);
      _log(
          'Vérification de connexion: ${isValid ? 'Connecté (token valide)' : 'Non connecté (token non valide)'}');
      return isValid;
    } catch (e) {
      _log('Erreur lors de la vérification de la connexion: $e');
      return false;
    }
  }

  // Méthode pour vérifier si un token JWT est valide
  Future<bool> isTokenValid(String token) async {
    try {
      // Vérification structurelle du token
      final parts = token.split('.');
      if (parts.length != 3) {
        _log('Token JWT invalide: format incorrect');
        return false;
      }

      // Décode la partie payload (sans vérifier la signature pour l'instant)
      final payloadBase64 = _normalizeBase64(parts[1]);
      final payloadJson = utf8.decode(base64Url.decode(payloadBase64));
      final payload = json.decode(payloadJson);

      // Vérification de l'expiration
      if (payload['exp'] != null) {
        final expiry =
            DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
        if (DateTime.now().isAfter(expiry)) {
          _log('Token JWT expiré');
          return false;
        }
      }

      // Si toutes les vérifications passent
      return true;
    } catch (e) {
      _log('Erreur lors de la validation du token: $e');
      return false;
    }
  }

  // Normalisation pour le décodage base64Url
  String _normalizeBase64(String input) {
    var output = input.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Base64Url string illegal length');
    }
    return output;
  }

  // Méthode pour se déconnecter
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      _log('Déconnexion réussie');
    } catch (e) {
      _log('Erreur lors de la déconnexion: $e');
      throw Exception('Erreur lors de la déconnexion: $e');
    }
  }

  // Méthode pour se connecter
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      _log('Tentative de connexion pour: $email');

      final response = await _client.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      _log(
          'Réponse du serveur pour la connexion - Status: ${response.statusCode}');
      _log('Réponse du serveur pour la connexion - Body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        final accessToken = responseData['data']['accessToken'];
        final refreshToken = responseData['data']['refreshToken'];

        await _storeTokens(accessToken, refreshToken);
        _log('Connexion réussie pour: $email');

        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData['data']
        };
      } else {
        _log(
            'Échec de la connexion pour: $email - Raison: ${responseData['message']}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      _log('Exception lors de la connexion: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Méthode pour s'inscrire (étape 1)
  Future<Map<String, dynamic>> signup(Map<String, String> signupData) async {
    try {
      _log(
          'Tentative d\'inscription - Étape 1 avec les données: ${signupData.toString()}');

      // Ajout d'un délai pour s'assurer que la requête est bien envoyée
      await Future.delayed(Duration(milliseconds: 500));

      final response = await _client
          .post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(signupData),
      )
          .timeout(Duration(seconds: 15), onTimeout: () {
        _log('TIMEOUT: La requête d\'inscription a expiré');
        throw Exception('La connexion au serveur a expiré');
      });

      _log(
          'Réponse du serveur pour l\'inscription étape 1 - Status: ${response.statusCode}');
      _log(
          'Réponse du serveur pour l\'inscription étape 1 - Body: ${response.body}');

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        _log('Erreur lors du décodage de la réponse JSON: $e');
        _log('Contenu brut de la réponse: ${response.body}');
        return {
          'success': false,
          'message': 'Erreur lors du décodage de la réponse: ${response.body}',
        };
      }

      if (response.statusCode == 201) {
        if (responseData['data'] == null ||
            responseData['data']['accessToken'] == null) {
          _log('Inscription réussie mais tokens manquants dans la réponse');
          return {
            'success': false,
            'message':
                'Inscription réussie mais erreur dans la réponse du serveur',
          };
        }

        final accessToken = responseData['data']['accessToken'];
        final refreshToken = responseData['data']['refreshToken'];

        await _storeTokens(accessToken, refreshToken);
        _log('Inscription étape 1 réussie');

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

        _log('Échec de l\'inscription étape 1 - Raison: $message');
        return {
          'success': false,
          'message': message ?? 'Signup failed',
        };
      }
    } catch (e) {
      _log('Exception lors de l\'inscription étape 1: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Méthode pour compléter l'inscription (étape 2)
  Future<Map<String, dynamic>> completeSignup(
      Map<String, String> completeData) async {
    try {
      _log(
          'Tentative d\'inscription - Étape 2 avec les données: ${completeData.toString()}');

      final accessToken = await getAccessToken();

      if (accessToken == null) {
        _log('Échec de l\'inscription étape 2 - Aucun access token disponible');
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
        _log('TIMEOUT: La requête de complétion d\'inscription a expiré');
        throw Exception('La connexion au serveur a expiré');
      });

      _log(
          'Réponse du serveur pour l\'inscription étape 2 - Status: ${response.statusCode}');
      _log(
          'Réponse du serveur pour l\'inscription étape 2 - Body: ${response.body}');

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        _log('Erreur lors du décodage de la réponse JSON: $e');
        _log('Contenu brut de la réponse: ${response.body}');
        return {
          'success': false,
          'message': 'Erreur lors du décodage de la réponse: ${response.body}',
        };
      }

      if (response.statusCode == 201) {
        // Vérifier s'il y a de nouveaux tokens à stocker
        if (responseData['data'] != null &&
            responseData['data']['accessToken'] != null) {
          final newAccessToken = responseData['data']['accessToken'];
          final newRefreshToken = responseData['data']['refreshToken'];

          await _storeTokens(newAccessToken, newRefreshToken);
        }

        _log('Inscription étape 2 réussie');
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

        _log('Échec de l\'inscription étape 2 - Raison: $message');
        return {
          'success': false,
          'message': message ?? 'Failed to complete registration',
        };
      }
    } catch (e) {
      _log('Exception lors de l\'inscription étape 2: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Méthode pour ajouter le token d'authentification aux headers de requête
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
      _log('Erreur lors de la récupération des en-têtes d\'auth: $e');
      return {'Content-Type': 'application/json'};
    }
  }
}
