import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_editor_page.dart';

import '../../../../models/games/game.dart' as Plock;
import '../../../../services/api.dart';
import 'Editor.dart';

class EditorPage extends StatefulWidget {
  final Plock.Game game;
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

  openEditor(BuildContext context) {
    return (ObjectComponent object) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ObjectEditorPage(
                    object: object,
                  )));
    };
  }

  addGameObject(GameObject gameObject) {
    widget.game.objects.add(gameObject);
  }

  removeGameObject(GameObject gameObject) {
    widget.game.objects.remove(gameObject);
  }

  updateGameObject(GameObject gameObject) {
    widget.game.objects.remove(gameObject);
    widget.game.objects.add(gameObject);
  }

  uploadGame(BuildContext context) {
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
