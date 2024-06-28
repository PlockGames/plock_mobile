import 'dart:convert';

import 'package:flame/components.dart';
import 'package:plock_mobile/services/api.dart';

import 'game_object.dart';

class Game {
  final String name;
  List<GameObject> objects = List<GameObject>.empty(growable: true);
  bool isDirty = false;
  Vector2 screenSize = Vector2(0, 0);

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
    String gameData = jsonDecode(gameDataResponse.body)["data"];
    gameData = gameData.replaceAll('\n', ' ');
    var dataJson = jsonDecode(gameData);
    var objects = dataJson['objects'];
    for (var object in objects) {
      game.objects.add(GameObject.fromJson(object));
    }

    return game;
  }
}