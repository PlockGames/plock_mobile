import 'dart:convert';
import 'package:http/http.dart' as http;
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