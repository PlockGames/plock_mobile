import 'dart:convert';

import 'package:flame/components.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/media.dart';

import '../../pages/play/game_player.dart';
import '../../pages/play/game_player_object.dart';
import '../../services/api.dart';
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

  /// URL to the game thumbnail image
  String? thumbnailUrl;

  /// Number of likes the game has received
  int likes = 0;

  /// Type of game (puzzle, arcade, etc.)
  String? gameType;

  /// Number of comments the game has received
  int commentsCount = 0;

  /// Tags associated with the game
  List<String> tags = [];

  /// ID of the game's creator.
  String creatorId = "";

  /// The username of the game's creator.
  String creatorUsername = "";

  /// The avatar URL of the game's creator.
  String creatorAvatarUrl = "";

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
    instance.uuid = uuid;
    instance.thumbnailUrl = thumbnailUrl;
    instance.likes = likes;
    instance.gameType = gameType;
    instance.commentsCount = commentsCount;
    instance.creatorId = creatorId;
    instance.creatorUsername = creatorUsername;
    instance.creatorAvatarUrl = creatorAvatarUrl;
    instance.tags = List.from(tags); // Copy the tags

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
      throw Exception(
          "Game player not set. Do not use outside of game player!");
    }

    GameObject newObject = GameObject(id: objectCount, name: name);
    scenes[currentSceneIndex].objects.add(newObject);
    GamePlayerObject newGamePlayerObject =
        GamePlayerObject(gameObject: newObject, plockGame: this);
    gamePlayer!.add(newGamePlayerObject);
    gamePlayer!.components.add(newGamePlayerObject);
    gamePlayer!.world.add(newGamePlayerObject);
    objectCount++;
    isDirty = true;
    return newObject.id;
  }

  int spawnAsset(String assetName, String name) {
    if (gamePlayer == null) {
      throw Exception(
          "Game player not set. Do not use outside of game player!");
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
    GamePlayerObject newGamePlayerObject =
        GamePlayerObject(gameObject: newObject, plockGame: this);
    gamePlayer!.add(newGamePlayerObject);
    gamePlayer!.components.add(newGamePlayerObject);
    gamePlayer!.world.add(newGamePlayerObject);
    objectCount++;
    isDirty = true;
    return newObject.id;
  }

  void destroyObject(int id) {
    if (gamePlayer == null) {
      throw Exception(
          "Game player not set. Do not use outside of game player!");
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
    json += "\"id\": \"$uuid\",";
    json += "\"name\": \"$name\",";
    json += "\"objectCount\": $objectCount,";
    json += "\"assetCount\": $assetCount,";
    json += "\"firstScene\": $firstScene,";
    json +=
        "\"thumbnailUrl\": ${thumbnailUrl != null ? "\"$thumbnailUrl\"" : "null"},";
    json += "\"gameType\": ${gameType != null ? "\"$gameType\"" : "null"},";
    json += "\"likes\": $likes,";

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

    return json;
  }

  /// Create a Game from a JSON object.
  static Future<Game?> jsonToGame(
      {required String name,
      required dynamic json,
      DateTime? lastUpdate}) async {
    try {
      Game game = Game(name: name);
      if (lastUpdate != null) {
        game.lastUpdate = lastUpdate;
      }

      game.scenes.clear();
      game.objectCount = json['objectCount'];

      // Asignar propiedades para las tarjetas si están disponibles
      game.thumbnailUrl = json['thumbnailUrl'];
      game.gameType = json['gameType'];
      game.likes = json['likes'] ?? 0;
      game.uuid = json['id'];

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

      final mediasResponse = await ApiService.getMedias(game.uuid);
      final mediasJson = jsonDecode(mediasResponse.body);

      // Verificar que mediasJson['data'] no sea nulo y sea una lista antes de iterar
      if (mediasJson != null &&
          mediasJson['data'] != null &&
          mediasJson['data'] is List) {
        for (var media in mediasJson['data']) {
          final int index = game.medias
              .indexWhere((element) => element.uuid == media['id']);
          if (index != -1) {
            final fileRes =
            await http.get(Uri.parse(media['filename'] ?? ''));
            final file = XFile.fromData(fileRes.bodyBytes);
            game.medias[index].file = file;
          }
        }
      }

      game.assets.clear();
      var jsonAssets = json['assets'];
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
