import 'dart:convert';

import 'package:flame/components.dart';
import 'package:plock_mobile/services/api.dart';

import 'game_object.dart';

/// A game.
class Game {

  /// The name of the game.
  final String name;

  /// The objects in the game.
  List<GameObject> objects = List<GameObject>.empty(growable: true);

  /// If the game is dirty.
  bool isDirty = false;

  /// The size of the screen.
  Vector2 screenSize = Vector2(0, 0);

  Game({required this.name});

  /// Convert the game to a JSON string.
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

  /// Create a Game from a JSON object.
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