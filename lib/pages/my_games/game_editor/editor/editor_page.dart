import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_callbacks.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_editor_page.dart';
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';

import '../../../../models/games/game.dart' as Plock;
import '../../../../models/games/media.dart';
import '../../../../models/games/scene.dart';
import '../assets_page.dart';
import '../medias_page.dart';
import '../objects_page.dart';
import '../scenes_page.dart';
import 'editor.dart';
import 'object_component.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';

/// The editor page.
class EditorPage extends StatefulWidget {
  /// The game to edit.
  final Plock.Game game;

  /// The current mode of the editor.
  //EditorMode mode = EditorMode.EDIT;

  EditorPage({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  _EditorPageState();

  /// Open the object editor.
  Function(
          ObjectComponent object, List<GameObject> objects, EditorCanvas canvas)
      openEditor(BuildContext context) {
    return (ObjectComponent object, List<GameObject> objects,
        EditorCanvas canvas) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ObjectEditorPage(
                    object: object,
                    objects: objects,
                    medias: widget.game.medias,
                    canvas: canvas,
                  )));
    };
  }

  /// Callback : Add a game object to the game.
  void addGameObject(GameObject gameObject) {
    widget.game.scenes[widget.game.currentSceneIndex].objects.add(gameObject);
  }

  /// Callback : Add a ui object to the game.
  void addUiGameObject(GameObject gameObject) {
    widget.game.scenes[widget.game.currentSceneIndex].uiObjects.add(gameObject);
  }

  /// Callback : Remove a game object from the game.
  void removeGameObject(GameObject gameObject) {
    widget.game.scenes[widget.game.currentSceneIndex].objects
        .remove(gameObject);
  }

  /// Callback : Remove a ui object from the game.
  void removeUiGameObject(GameObject gameObject) {
    widget.game.scenes[widget.game.currentSceneIndex].uiObjects
        .remove(gameObject);
  }

  /// Callback : Remove an object depending on the current canvas.
  void removeObject(ObjectComponent object, EditorCanvas canvas) {
    if (canvas == EditorCanvas.scene) {
      removeGameObject(object.getGameObject());
    } else {
      removeUiGameObject(object.getGameObject());
    }
  }

  /// Callback : Remove a scene from the game.
  void removeScene(Scene scene) {
    widget.game.scenes.remove(scene);
  }

  void addScene(Scene scene) {
    widget.game.scenes.add(scene);
  }

  /// Callback : Update a game object in the game.
  void updateGameObject(GameObject gameObject) {
    widget.game.scenes[widget.game.currentSceneIndex].objects
        .remove(gameObject);
    widget.game.scenes[widget.game.currentSceneIndex].objects.add(gameObject);
  }

  /// Callback : Update a ui object in the game.
  void updateUiGameObject(GameObject gameObject) {
    widget.game.scenes[widget.game.currentSceneIndex].uiObjects
        .remove(gameObject);
    widget.game.scenes[widget.game.currentSceneIndex].uiObjects.add(gameObject);
  }

  /// Callback : Upload the game to the server and close the editor.
  Function() uploadGame(BuildContext context) {
    return () async {
      if (widget.game.uuid.isEmpty) {
        // Create the game

        var upload = await ApiService.createGame(CreateGameDto(
          title: widget.game.name,
          tags: [],
          playTime: "0",
          gameType: "test",
          thumbnailUrl:
              "https://w7.pngwing.com/pngs/378/59/png-transparent-old-school-runescape-internet-meme-youtube-random-game-child-face-thumbnail.png",
          contentGame: widget.game.toJson(),
        ));
        var json = jsonDecode(upload.body);
        final String uuid = json['data']['id'];
        widget.game.uuid = uuid;
      } else {
        // Update the game
        var upload = await ApiService.updateGame(
            widget.game.uuid,
            UpdateGameDto(
              title: "${widget.game.name}",
              tags: [],
              playTime: "0",
              gameType: "test",
              thumbnailUrl:
                  "https://w7.pngwing.com/pngs/378/59/png-transparent-old-school-runescape-internet-meme-youtube-random-game-child-face-thumbnail.png",
              contentGame: widget.game.toJson(),
              id: widget.game.uuid,
            ));
      }

      // upload images
      List<Media> medias = widget.game.medias;
      for (var media in medias) {
        if (media.file != null) {
          var res = await ApiService.uploadMedia(
              widget.game.uuid, await media.file!.readAsBytes());
          final json = jsonDecode(res.body);
          final String uuid = json['data'][0]['id'];
          media.uuid = uuid;
        }
      }

      // reupdate game with new ids
      final finalRes = await ApiService.updateGame(
          widget.game.uuid,
          UpdateGameDto(
            title: "${widget.game.name}",
            tags: [],
            playTime: "0",
            gameType: "test",
            thumbnailUrl:
                "https://w7.pngwing.com/pngs/378/59/png-transparent-old-school-runescape-internet-meme-youtube-random-game-child-face-thumbnail.png",
            contentGame: widget.game.toJson(),
            id: widget.game.uuid,
          ));

      print(finalRes.body);

      // Navegar a la página my_games_page en lugar de simplemente volver a la raíz
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyGamesPage(),
          settings: const RouteSettings(name: '/my_games'),
        ),
      );
    };
  }

  Function() testGame(BuildContext context) {
    return () async {
      Plock.Game tempGame = widget.game.instance();
      tempGame.currentSceneIndex = tempGame.firstScene;
      print(tempGame.scenes[tempGame.firstScene].objects.length);

      for (var object in tempGame.scenes[tempGame.firstScene].objects) {
        for (var component in object.components) {
          if (component is ComponentEvent) {
            ComponentEvent event = component;
            event.fields['event']!.value[0] =
                event.fields['event']!.value[0].replaceAll('\n', ' ');
            event.fields['event']!.value[0] =
                event.fields['event']!.value[0].replaceAll('\\"', '"');
          }
        }
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GameWidget(
                  game: GamePlayer(
                      game: tempGame,
                      isTest: true,
                      exitGame: goBack(context),
                      uploadGame: uploadGame(context)))));
    };
  }

  Function() goBack(BuildContext context) {
    return () {
      Navigator.pop(context);
    };
  }

  Function(List<ObjectComponent>, EditorCanvas canvas) openObjects(
      BuildContext context) {
    return (List<ObjectComponent> objects, EditorCanvas canvas) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ObjectsPage(
                  objects: objects,
                  openEditor: openEditor(context),
                  canvas: canvas,
                  removeObject: removeObject)));
    };
  }

  Function(Function(GameObject), Function(GameObject), EditorCanvas canvas)
      openAssets(BuildContext context) {
    return (Function(GameObject) spawnAsset, Function(GameObject) updateAsset,
        EditorCanvas canvas) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AssetsPage(
                  game: widget.game,
                  spawnAsset: spawnAsset,
                  updateAsset: updateAsset,
                  canvas: canvas)));
    };
  }

  Function() openMedias(BuildContext context) {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MediasPage(game: widget.game)));
    };
  }

  Function(Function(Scene)) openScenes(BuildContext context) {
    return (Function(Scene) changeScene) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScenesPage(
                  scenes: widget.game.scenes,
                  removeScene: removeScene,
                  changeScene: changeScene,
                  selectedScene: widget.game.currentSceneIndex)));
    };
  }

  @override
  Widget build(BuildContext context) {
    EditorCallbacks callbacks = EditorCallbacks(
      openEditor: openEditor(context),
      addGameObject: addGameObject,
      addUIObject: addUiGameObject,
      removeGameObject: removeGameObject,
      removeUIObject: removeUiGameObject,
      updateGameObject: updateGameObject,
      updateUIObject: updateUiGameObject,
      testGame: testGame(context),
      goBack: goBack(context),
      openObjects: openObjects(context),
      openAssets: openAssets(context),
      openMedias: openMedias(context),
      openScenes: openScenes(context),
    );

    return Column(
      children: <Widget>[
        Expanded(
          child: GameWidget(
            key: Key("editor_game"),
            game: Editor(
              game: widget.game,
              editorCallbacks: callbacks,
            ),
          ),
        ),
      ],
    );
  }
}
