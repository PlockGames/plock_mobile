import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to interact with the API (plock backend)
class ApiService {
  // TODO: change to env variable
  static String url = "http://141.94.223.12:3000";

  /// Return a list of all the games.
  ///
  /// If [page] is not null, it will return the games of that page only.
  static Future<http.Response> getAllGames(int? page) async {
    if (page != null) {
      return await http.get(Uri.parse("$url/games?page=$page"));
    }
    return await http.get(Uri.parse("$url/games"));
  }

  /// Return a list of the game with the given [id].
  static Future<http.Response> getGame(String id) async {
    return await http.get(Uri.parse("$url/games/$id"));
  }

  /// Return the game with the given [id] and its game data.
  static Future<http.Response> getGameWithData(String id) async {
    return await http.get(Uri.parse("$url/games/full/$id"));
  }

  /// Create a new game with the given [data].
  static Future<http.Response> createGame(CreateGameDto data) async {
    return await http.post(Uri.parse("$url/games"), body: data.toJson(), headers: {
      "Content-Type": "application/json",
    });
  }
}

class CreateGameDto {
  final String title;
  final List<String> tags;
  final int creatorId;
  final String playTime;
  final String gameType;
  final String thumbnailUrl;
  final String data;

  CreateGameDto({
    required this.title,
    required this.tags,
    required this.creatorId,
    required this.playTime,
    required this.gameType,
    required this.thumbnailUrl,
    required this.data,
  });

  /// Convert the object to a json string.
  String toJson() {
    const json = JsonEncoder();
    var res = json.convert({
      "title": title,
      "tags": tags,
      "creatorId": creatorId,
      "playTime": playTime,
      "gameType": gameType,
      "thumbnailUrl": thumbnailUrl,
      "data": data,
    });
    return res;
  }
}