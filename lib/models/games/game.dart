import 'dart:convert';

import 'package:flame/components.dart';
import 'package:plock_mobile/services/api.dart';

import '../../pages/play/game_player.dart';
import '../../pages/play/game_player_object.dart';
import 'game_object.dart';

/// A game.
class Game {

  /// The name of the game.
  final String name;

  /// The objects in the game.
  List<GameObject> objects = List<GameObject>.empty(growable: true);

  /// If the game is dirty.
  bool isDirty = false;

  /// Object count, used to assign id
  int objectCount = 0;

  /// The size of the screen.
  Vector2 screenSize = Vector2(0, 0);

  /// Store the delta time between two frames.
  double deltaTime = 0;

  /// The game player.
  ///
  /// Set at runtime when the game is played, used to spawn and destroy objects.
  GamePlayer? gamePlayer;

  Game({required this.name});

  Game instance() {
    Game instance = Game(name: name);
    instance.screenSize = screenSize;
    instance.objectCount = objectCount;

    for (var object in objects) {
      instance.objects.add(object.instance());
    }

    return instance;
  }

  int spawnObject(String name) {
    if (gamePlayer == null) {
      throw Exception("Game player not set. Do not use outside of game player!");
    }

    GameObject newObject = GameObject(id: objectCount, name: name);
    objects.add(newObject);
    GamePlayerObject newGamePlayerObject = GamePlayerObject(gameObject: newObject, game: this);
    gamePlayer!.add(newGamePlayerObject);
    gamePlayer!.components.add(newGamePlayerObject);
    objectCount++;
    isDirty = true;
    return newObject.id;
  }

  void destroyObject(int id) {
    if (gamePlayer == null) {
      throw Exception("Game player not set. Do not use outside of game player!");
    }

    GamePlayerObject? object = gamePlayer!.components.firstWhere((element) {
      return (element as GamePlayerObject).gameObject.id == id;
      }) as GamePlayerObject?;
    if (object != null) {
      objects.remove(object.gameObject);
      for (var component in object.displayComponents) {
        object.remove(component);
      }
      object.displayComponents = [];
      gamePlayer!.remove(object);
      isDirty = true;
    }
  }

  /// Convert the game to a JSON string.
  String toJson() {
    String json = "{";
    json += "\"name\": \"$name\",";
    json += "\"objectCount\": $objectCount,";
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

    try {
      Game game = Game(name: json['name']);
      game.objectCount = json['objectCount'];
      var objects = json['objects'];
      for (var object in objects) {
        game.objects.add(GameObject.fromJson(object));
      }

      return game;
    } catch (e) {
      print(e);
      return null;
    }
  }
}