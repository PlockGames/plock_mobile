import 'dart:convert';

import 'package:plock_mobile/services/api.dart';

import 'game_object.dart';

class Game {
  final String name;
  List<GameObject> objects = List<GameObject>.empty(growable: true);

  Game({required this.name});

  String toJson() {
    String json = "{";
    json += "\"name\": \"$name\",";
    json += "\"objects\": [";
    objects.forEach((element) {
      json += element.toJson();
      if (objects.indexOf(element) != objects.length - 1) {
        json += ",";
      }
    });
    json += "]";
    json += "}";
    return json;
  }

  static jsonToGame(Map<String, dynamic> json) async {
    Game game = Game(name: json['title']);
    var gameDataResponse = await ApiService.getGameWithData(json['id'].toString());
    var gameData = jsonDecode(gameDataResponse.body)["data"];
    var objects = jsonDecode(gameData)["objects"];
    for (var object in objects) {
      game.objects.add(GameObject.fromJson(object));
    }

    return game;
  }
}