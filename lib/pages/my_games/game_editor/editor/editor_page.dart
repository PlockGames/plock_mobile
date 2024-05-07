import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/flame_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_editor_page.dart';

import '../../../../models/games/game.dart' as Plock;
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
  _EditorPageState createState() => _EditorPageState(game: game);
}

class _EditorPageState extends State<EditorPage> {
  final Plock.Game game;

  _EditorPageState({required this.game});

  openEditor(BuildContext context) {
    return (ObjectComponent object) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ObjectEditorPage(
                    gameObject: object.gameObject,
                    // onGameObjectUpdated: (updatedGameObject) {
                    //   setState(() {
                    //     // currentGameObject = updatedGameObject;
                    //   });
                    // })),
                  )));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GameWidget(
              game: Editor({openEditor: openEditor(context), game: game})),
        ),
      ],
    );
  }
}
