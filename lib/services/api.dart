import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static String url = "http://141.94.223.12:3000";

  static Future<http.Response> getAllGames(int? page) async {
    if (page != null) {
      return await http.get(Uri.parse("$url/games?page=$page"));
    }
    return await http.get(Uri.parse("$url/games"));
  }

  static Future<http.Response> getGame(String id) async {
    return await http.get(Uri.parse("$url/games/$id"));
  }

  static Future<http.Response> getGameWithData(String id) async {
    return await http.get(Uri.parse("$url/games/full/$id"));
  }

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