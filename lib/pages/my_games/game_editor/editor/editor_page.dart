import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_editor_page.dart';

import '../../../../models/games/game.dart' as Plock;
import '../../../../services/api.dart';
import 'Editor.dart';

/// The editor page.
class EditorPage extends StatefulWidget {

  /// The game to edit.
  final Plock.Game game;

  /// The callback function to update a game object.
  final Function(GameObject) onGameObjectUpdated;

  EditorPage({
    Key? key,
    required this.game,
    required this.onGameObjectUpdated,
  }) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {

  _EditorPageState();

  /// Open the object editor.
  Function openEditor(BuildContext context) {
    return (ObjectComponent object) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ObjectEditorPage(
                    object: object,
                  )));
    };
  }

  /// Callback : Add a game object to the game.
  void addGameObject(GameObject gameObject) {
    widget.game.objects.add(gameObject);
  }

  /// Callback : Remove a game object from the game.
  void removeGameObject(GameObject gameObject) {
    widget.game.objects.remove(gameObject);
  }

  /// Callback : Update a game object in the game.
  void updateGameObject(GameObject gameObject) {
    widget.game.objects.remove(gameObject);
    widget.game.objects.add(gameObject);
  }

  /// Callback : Upload the game to the server and close the editor.
  Function uploadGame(BuildContext context) {
    return () async {
      var upload = await ApiService.createGame(CreateGameDto(
        title: widget.game.name,
        tags: [],
        creatorId: 1,
        playTime: "0",
        gameType: "test",
        thumbnailUrl: "",
        data: widget.game.toJson(),
      ));
      Navigator.pop(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GameWidget(
              game: Editor(
                  openEditor: openEditor(context),
                  game: widget.game,
                  addGameObject: addGameObject,
                  removeGameObject: removeGameObject,
                  updateGameObject: updateGameObject,
                  uploadGame: uploadGame(context),
              ),
          ),
        ),
      ],
    );
  }
}
