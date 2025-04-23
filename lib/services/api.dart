import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'http_client_service.dart';
import 'api_service.dart';

/// Service to interact with the API (plock backend)
class ApiService {
  static final String url =
      dotenv.env['API_URL'] ?? 'http://localhost:3000/api';
  static final HttpClientService _httpClient = HttpClientService();

  /// Returns a list of all games.
  ///
  /// If [page] is not null, it will return the games for that specific page only.
  static Future<http.Response> getAllGames(int? page) async {
    if (page != null) {
      return await _httpClient.get("/game?page=$page&perPage=3");
    }
    return await _httpClient.get("/game");
  }

  /// Returns only the games of the current user.
  ///
  /// If [page] is not null, it will return the games for that specific page only.
  static Future<http.Response> getMyGames(int? page) async {
    if (page != null) {
      return await _httpClient.get("/game/my?page=$page&perPage=10");
    }
    return await _httpClient.get("/game/my");
  }

  /// Retrieves the profile of the currently authenticated user.
  static Future<http.Response> getUserProfile() async {
    final response = await _httpClient
        .get("/auth/me", headers: {"Accept": "application/json"});
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
  }

  /// Updates the profile of the currently authenticated user.
  static Future<http.Response> updateUserProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? birthDate,
    String? username,
    String? password,
  }) async {
    // Create an object that contains only the non-null fields
    final Map<String, dynamic> updateData = {};
    if (email != null) updateData['email'] = email;
    if (firstName != null) updateData['firstName'] = firstName;
    if (lastName != null) updateData['lastName'] = lastName;
    if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
    if (birthDate != null) updateData['birthDate'] = birthDate;
    if (username != null) updateData['username'] = username;
    if (password != null) updateData['password'] = password;

    final response = await _httpClient.put("/user/profile/me", updateData,
        headers: {"Accept": "application/json"});

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response;
  }

  /// Returns information about the game with the specified [id].
  static Future<http.Response> getGame(String id) async {
    return await _httpClient.get("/game/$id");
  }

  /// Returns the total number of likes for a given game [gameId].
  static Future<http.Response> getGameLike(String gameId) async {
    final response = await _httpClient
        .get("/like/count/$gameId", headers: {"Accept": "application/json"});
    print("gameId: ${gameId}");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response;
  }

  /// Deletes the like of a game by its [id].
  static Future<http.Response> deleteGame(String gameId) async {
    final response = await _httpClient.delete("/like/$gameId");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
  }

  /// Adds a like to a game.
  static Future<http.Response> addLikeGame(String gameId) async {
    final response = await _httpClient.post("/like", {"gameId": gameId});
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    return response;
  }

  /// Creates a new game with the provided [data].
  static Future<http.Response> createGame(CreateGameDto data) async {
    return await _httpClient.post("/game", data.toJson());
  }

  /// Updates an existing game.
  static Future<http.Response> updateGame(String id, UpdateGameDto data) async {
    return await _httpClient.put("/game/$id?id=$id", data.toJson());
  }

  /// Uploads a media file for a game.
  static Future<http.Response> uploadMedia(
      String gameId, Uint8List data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$url/game/$gameId/images"));

    // Get the access token
    final response = await _httpClient.multipartRequest(
        "/game/$gameId/images", {}, {'images': data},
        headers: {"Content-Type": "multipart/form-data"});

    print(response.body);
    return response;
  }

  /// Retrieves the media associated with a game.
  static Future<http.Response> getMedias(String gameId) async {
    return await _httpClient.get("/game/$gameId/images");
  }

  /// Returns a list of recommended games.
  ///
  /// If [page] is not null, it will return the recommended games for that specific page.
  static Future<http.Response> getRecommendedGames(int? page) async {
    if (page != null) {
      return await _httpClient
          .get("/game/recommendation?page=$page&perPage=10");
    }
    return await _httpClient.get("/game/recommendation");
  }

  /// Returns a list of available tags.
  ///
  /// If [page] is not null, it will return the tags for that specific page.
  static Future<http.Response> getTags(int? page) async {
    if (page != null) {
      return await _httpClient.get("/tag?page=$page&perPage=10");
    }
    return await _httpClient.get("/tag");
  }

  /// Returns a list of comments for a specific game.
  ///
  /// If [page] is not null, it will return the comments for that specific page.
  static Future<http.Response> getGameComments(String gameId,
      {int? page}) async {
    if (page != null) {
      return await _httpClient
          .get("/comment/game/$gameId?page=$page&perPage=10");
    }
    return await _httpClient.get("/comment/game/$gameId");
  }

  /// Adds a comment to a game.
  static Future<http.Response> addGameComment(
      String gameId, String content) async {
    return await _httpClient.post("/comment/$gameId", {"content": content});
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

  /// Converts the object to a JSON string.
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

  /// Converts the object to a JSON string.
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
