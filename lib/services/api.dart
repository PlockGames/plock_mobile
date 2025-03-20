import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service to interact with the API (plock backend)
class ApiService {

  static String? url = dotenv.env['API_URL'];
  static String? apiKey = dotenv.env['API_KEY'];

  /// Return a list of all the games.
  ///
  /// If [page] is not null, it will return the games of that page only.
  static Future<http.Response> getAllGames(int? page) async {
    if (page != null) {
      http.Response res = await http.get(Uri.parse("$url/game?page=$page&perPage=3"), headers: {
        "Authorization": "Bearer $apiKey",
      });
      return res;
    }
    http.Response res = await http.get(Uri.parse("$url/game"), headers: {
      "Authorization": "Bearer $apiKey",
    });
    return res;
  }

  /// Get the profile of the currently authenticated user.
  static Future<http.Response> getUserProfile() async {
    final response = await http.get(
      Uri.parse("$url/auth/me"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Accept": "application/json",
      },
    );
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
  }
  /// Met à jour le profil de l'utilisateur actuellement authentifié.
  static Future<http.Response> updateUserProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? birthDate,
    String? username,
    String? password,
  }) async {
    // Créer un objet contenant uniquement les champs non-null
    final Map<String, dynamic> updateData = {};
    if (email != null) updateData['email'] = email;
    if (firstName != null) updateData['firstName'] = firstName;
    if (lastName != null) updateData['lastName'] = lastName;
    if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
    if (birthDate != null) updateData['birthDate'] = birthDate;
    if (username != null) updateData['username'] = username;
    if (password != null) updateData['password'] = password;

    final response = await http.put(
      Uri.parse("$url/user/profile/me"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(updateData),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response;
  }

  /// Return a list of the game with the given [id].
  static Future<http.Response> getGame(String id) async {
    return await http.get(Uri.parse("$url/game/$id"), headers: {
      "Authorization": "Bearer $apiKey"
    });
  }
  /// Retourne le nombre total de likes pour un jeu donné [gameId].
  static Future<http.Response> getGameLike(String gameId) async {
    final response = await http.get(
      Uri.parse("$url/like/count/$gameId"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Accept": "application/json",
      },
    );
    print("gameId: ${gameId}");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response;
  }


  /// Supprime le like d'un jeu donné par son [id].
  static Future<http.Response> deleteGame(String gameId) async {
    final response = await http.delete(
      Uri.parse("$url/like/$gameId"),
      headers: {
        "Authorization": "Bearer $apiKey",
      },
    );
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
  }
  static Future<http.Response> addLikeGame(String gameId) async {
    final response = await http.post(
      Uri.parse("$url/like"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "gameId": gameId,
      }),
    );
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
  }




  /// Create a new game with the given [data].
  static Future<http.Response> createGame(CreateGameDto data) async {
    return await http.post(Uri.parse("$url/game"), body: data.toJson(), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey"
    });
  }

  static Future<http.Response> updateGame(String id, UpdateGameDto data) async {
    return await http.put(Uri.parse("$url/game/$id?id=$id"), body: data.toJson(), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey"
    });
  }

  static Future<http.Response> deleteGame(String id) async {
    final res = await http.delete(Uri.parse("$url/game/$id"), headers: {
      "Authorization": "Bearer $apiKey"
    });
    return res;
  }

  static Future<http.Response> uploadMedia(String gameId, Uint8List data) async {
    http.MultipartFile file = http.MultipartFile.fromBytes('images', data, filename: "image.png", contentType: http.MediaType("image", "png"));
    final body = http.MultipartRequest("POST", Uri.parse("$url/game/$gameId/images"));
    body.files.add(file);
    body.headers.addAll({
      "Authorization": "Bearer $apiKey",
      "Content-Type": "multipart/form-data",
    });
    final res = await body.send();
    final httpRes = await http.Response.fromStream(res);
    print(httpRes.body);
    return httpRes;
  }

  static Future<http.Response> getMedias(String gameId) async {
    final res = await http.get(Uri.parse("$url/game/$gameId/images"), headers: {
      "Authorization": "Bearer $apiKey"
    });
    return res;
  }
}

class CreateGameDto {
  final String title;
  final List<String> tags;
  final String playTime;
  final String gameType;
  final String thumbnailUrl;
  final String contentGame;

  CreateGameDto({
    required this.title,
    required this.tags,
    required this.playTime,
    required this.gameType,
    required this.thumbnailUrl,
    required this.contentGame,
  });

  /// Convert the object to a json string.
  String toJson() {
    const json = JsonEncoder();
    var res = json.convert({
      "title": title,
      "tags": tags,
      "playTime": playTime,
      "gameType": gameType,
      "thumbnailUrl": thumbnailUrl,
      "contentGame": jsonDecode(contentGame),
    });
    return res;
  }
}

class UpdateGameDto {
  final String id;
  final String title;
  final List<String> tags;
  final String playTime;
  final String gameType;
  final String thumbnailUrl;
  final String contentGame;

  UpdateGameDto({
    required this.id,
    required this.title,
    required this.tags,
    required this.playTime,
    required this.gameType,
    required this.thumbnailUrl,
    required this.contentGame,
  });

  /// Convert the object to a json string.
  String toJson() {
    const json = JsonEncoder();
    var res = json.convert({
      "id": id,
      "title": title,
      "tags": tags,
      "playTime": playTime,
      "gameType": gameType,
      "thumbnailUrl": thumbnailUrl,
      "contentGame": jsonDecode(contentGame),
    });
    return res;
  }
}