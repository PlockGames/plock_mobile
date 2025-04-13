import 'dart:convert';
import 'dart:typed_data';

import 'api_service.dart';

/// Service to interact with the API (plock backend)
class Api {
  static final ApiService _apiService = ApiService();

  // Fonction de log simple
  static void _log(String message) {
    print("Api: $message");
  }

  /// Return a list of all the games.
  ///
  /// If [page] is not null, it will return the games of that page only.
  static Future<Map<String, dynamic>> getAllGames(int? page) async {
    if (page != null) {
      _log("Getting all games with page: $page");
      Map<String, dynamic> res = await _apiService.get("/game?page=$page&perPage=3");
      return res;
    }
    _log("Getting all games");
    Map<String, dynamic> res = await _apiService.get("/game");
    return res;
  }

  /// Get the profile of the currently authenticated user.
  static Future<Map<String, dynamic>> getUserProfile() async {
    _log("Getting user profile");
    final response = await _apiService.get("/auth/me");
    return response;
  }
  /// Met à jour le profil de l'utilisateur actuellement authentifié.
  static Future<Map<String, dynamic>> updateUserProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? birthDate,
    String? username,
    String? password,
  }) async {
    _log("Updating user profile");
    // Créer un objet contenant uniquement les champs non-null
    final Map<String, dynamic> updateData = {};
    if (email != null) updateData['email'] = email;
    if (firstName != null) updateData['firstName'] = firstName;
    if (lastName != null) updateData['lastName'] = lastName;
    if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
    if (birthDate != null) updateData['birthDate'] = birthDate;
    if (username != null) updateData['username'] = username;
    if (password != null) updateData['password'] = password;

    final response = await _apiService.put("/user/profile/me", updateData);

    return response;
  }

  /// Return a list of the game with the given [id].
  static Future<Map<String, dynamic>> getGame(String id) async {
    _log("Getting game with id: $id");
    return await _apiService.get("/game/$id");
  }

  /// Retourne le nombre total de likes pour un jeu donné [gameId].
  static Future<Map<String, dynamic>> getGameLike(String gameId) async {
    _log("Getting the game like with id: $gameId");
    final response = await _apiService.get("/like/count/$gameId");

    return response;
  }

  /// Supprime le like d'un jeu donné par son [id].
  static Future<Map<String, dynamic>> deleteLikeGame(String gameId) async {
    _log("Deleting like of game with id: $gameId");
    final response = await _apiService.delete("/like/$gameId");
    return response;
  }

  /// Ajoute un like à un jeu donné par son [id].
  static Future<Map<String, dynamic>> addLikeGame(String gameId) async {
    _log("Adding like game with id: $gameId");
    final response = await _apiService.post("/like",
      {
        "gameId": gameId,
      }
    );
    return response;
  }

  /// Create a new game with the given [data].
  static Future<Map<String, dynamic>> createGame(CreateGameDto data) async {
    _log("Creating a game");
    return await _apiService.post("/game", data.toJson());
  }

  /// Delete a game with the given [id].
  static Future<Map<String, dynamic>> deleteGame(String id) async {
    _log("Deleting game with id: $id");
    return await _apiService.delete("/game/$id");
  }

  static Future<Map<String, dynamic>> updateGame(String id, UpdateGameDto data) async {
    _log("Updating game with id: $id");
    return await _apiService.put("/game/$id?id=$id", data.toJson());
  }

  static Future<Map<String, dynamic>> uploadMedia(String gameId, Uint8List data) async {
    _log("Uploading media for game with id: $gameId");
    return await _apiService.uploadMedia("/game/$gameId/images", data);
  }

  static Future<Map<String, dynamic>> getMedias(String gameId) async {
    _log("Getting medias for game with id: $gameId");
    return await _apiService.get("/game/$gameId/images");
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
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "tags": tags,
      "playTime": playTime,
      "gameType": gameType,
      "thumbnailUrl": thumbnailUrl,
      "contentGame": jsonDecode(contentGame),
    };
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
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "tags": tags,
      "playTime": playTime,
      "gameType": gameType,
      "thumbnailUrl": thumbnailUrl,
      "contentGame": jsonDecode(contentGame),
    };
  }
}