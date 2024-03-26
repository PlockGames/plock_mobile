import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/flame_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_editor_page.dart';

import '../../../../models/games/game.dart' as Plock;
import 'Editor.dart';

class EditorPage extends StatelessWidget {
  Plock.Game game;
  EditorPage({Key? key, required this.game}) : super(key: key);

  openEditor(context) {
    return (ObjectComponent object) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ObjectEditorPage(gameObject: object.gameObject)),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GameWidget(game: Editor(openEditor(context))),
        ),
      ],
    );
  }
}
