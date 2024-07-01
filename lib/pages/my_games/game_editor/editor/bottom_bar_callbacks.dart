import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

class BottomBarCallbacks {
  final Function(ObjectComponent? object) selectObject;
  final Function(ObjectComponent object) openEditor;
  final ObjectComponent Function()  addGameObject;
  final Function(ObjectComponent object) updateObject;
  final Function(ObjectComponent object) removeGameObject;
  final Function getSelectedObject;
  final Function() uploadGame;
  final Function() goBack;

  BottomBarCallbacks({
    required this.selectObject,
    required this.openEditor,
    required this.addGameObject,
    required this.updateObject,
    required this.removeGameObject,
    required this.getSelectedObject,
    required this.uploadGame,
    required this.goBack,
  });
}