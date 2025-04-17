
import 'package:flame/components.dart';
import 'package:plock_mobile/models/games/media.dart';

import '../../pages/play/game_player.dart';
import '../../pages/play/game_player_object.dart';
import 'game_object.dart';
import 'media/media_set.dart';
import 'scene.dart' as Plock;

/// A game.
class Game {
  /// The scenes of the game.
  List<Plock.Scene> scenes = List<Plock.Scene>.empty(growable: true);

  /// The name of the first scene.
  int firstScene = 0;

  /// The current scene index.
  int currentSceneIndex = 0;

  /// The uuid of the game.
  String uuid = "";

  /// The name of the game.
  final String name;

  /// The last update time.
  DateTime lastUpdate = DateTime.now();

  /// The assets of the game.
  List<GameObject> assets = List<GameObject>.empty(growable: true);

  /// the UI assets of the game
  List<GameObject> uiAssets = List<GameObject>.empty(growable: true);

  /// The medias of the game.
  List<Media> medias = List<Media>.empty(growable: true);

  /// If the game is dirty.
  bool isDirty = false;

  /// Object count, used to assign id.
  int objectCount = 0;

  /// Asset count, used to assign id
  int assetCount = 0;

  /// The size of the screen.
  Vector2 screenSize = Vector2(0, 0);

  /// Store the delta time between two frames.
  double deltaTime = 0;

  /// The last touch position.
  Vector2 lastTouchPosition = Vector2(0, 0);

  /// The game player.
  /// Set at runtime when the game is played, used to spawn and destroy objects.
  GamePlayer? gamePlayer;

  Game({required this.name}) {
    scenes.add(Plock.Scene(name: "scene"));
  }

  Game instance() {
    Game instance = Game(name: name);
    instance.screenSize = screenSize;
    instance.objectCount = objectCount;
    instance.assetCount = assetCount;
    instance.currentSceneIndex = currentSceneIndex;
    instance.firstScene = firstScene;

    instance.scenes.clear();

    for (var scene in scenes) {
      instance.scenes.add(scene.instance());
    }


    for (var asset in assets) {
      instance.assets.add(asset.instance());
    }

    for (var media in medias) {
      instance.medias.add(media.instance());
    }

    return instance;
  }

  int spawnObject(String name) {
    if (gamePlayer == null) {
      throw Exception("Game player not set. Do not use outside of game player!");
    }

    GameObject newObject = GameObject(id: objectCount, name: name);
    scenes[currentSceneIndex].objects.add(newObject);
    GamePlayerObject newGamePlayerObject = GamePlayerObject(gameObject: newObject, plockGame: this);
    gamePlayer!.add(newGamePlayerObject);
    gamePlayer!.components.add(newGamePlayerObject);
    gamePlayer!.world.add(newGamePlayerObject);
    objectCount++;
    isDirty = true;
    return newObject.id;
  }

  int spawnAsset(String assetName, String name) {
    if (gamePlayer == null) {
      throw Exception("Game player not set. Do not use outside of game player!");
    }

    GameObject asset;

    try {
      asset = assets.firstWhere((element) => element.name == assetName);
    } catch (e) {
      try {
        asset = uiAssets.firstWhere((element) => element.name == assetName);
      } catch (e) {
        throw Exception("Asset not found");
      }
    }

    GameObject newObject = asset.instance();
    newObject.id = objectCount;
    newObject.name = name;

    scenes[currentSceneIndex].objects.add(newObject);
    GamePlayerObject newGamePlayerObject = GamePlayerObject(gameObject: newObject, plockGame: this);
    gamePlayer!.add(newGamePlayerObject);
    gamePlayer!.components.add(newGamePlayerObject);
    gamePlayer!.world.add(newGamePlayerObject);
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
      scenes[currentSceneIndex].objects.remove(object.gameObject);
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
    json += "\"id\": \"$uuid\","; // This can be null, so ensure you handle it accordingly
    json += "\"name\": \"$name\",";
    json += "\"objectCount\": $objectCount,";
    json += "\"assetCount\": $assetCount,";
    json += "\"firstScene\": $firstScene,";

    json += "\"assets\": [";
    assets.forEach((element) {
      json += element.toJson();
      if (assets.indexOf(element) != assets.length - 1) {
        json += ",";
      }
    });
    json += "],";

    json += "\"uiAssets\": [";
    uiAssets.forEach((element) {
      json += element.toJson();
      if (uiAssets.indexOf(element) != uiAssets.length - 1) {
        json += ",";
      }
    });
    json += "],";

    // add medias
    json += "\"medias\": [";
    medias.forEach((element) {
      json += element.toJson();
      if (medias.indexOf(element) != medias.length - 1) {
        json += ",";
      }
    });
    json += "],";

    // add scenes
    json += "\"scenes\": [";
    scenes.forEach((element) {
      json += element.toJson();
      if (scenes.indexOf(element) != scenes.length - 1) {
        json += ",";
      }
    });
    json += "]";
    json += "}";

    json = json.replaceAll("\n", "");

    print(json);
    return json;
  }

  /// Create a Game from a JSON object.
  static jsonToGame({required String name, required Map<String, dynamic> json, DateTime? lastUpdate}) async {

    try {
      Game game = Game(name: name);
      if (lastUpdate != null) {
        game.lastUpdate = lastUpdate;
      }



      game.scenes.clear();
      game.objectCount = json['objectCount'];
      var jsonScene = json['scenes'];
      for (var scene in jsonScene) {
        game.scenes.add(Plock.Scene.fromJson(scene));
      }

      var jsonMedias = json['medias'];
      for (var media in jsonMedias) {
        if (media['isSet'] == true) {
          game.medias.add(MediaSet.fromJson(media));
        } else {
          game.medias.add(Media.fromJson(media));
        }
      }

      game.assets.clear();
      var jsonAssets = json['assets'];
      print(jsonAssets);
      for (var asset in jsonAssets) {
        GameObject assetObject = GameObject.fromJson(asset);
        game.assets.add(assetObject);
      }

      game.uiAssets.clear();
      var jsonUiAssets = json['uiAssets'];
      for (var asset in jsonUiAssets) {
        GameObject assetObject = GameObject.fromJson(asset);
        game.uiAssets.add(assetObject);
      }

      return game;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
