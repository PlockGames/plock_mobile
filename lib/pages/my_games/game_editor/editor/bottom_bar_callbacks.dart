import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

class BottomBarCallbacks {
  final Function(ObjectComponent? object) selectObject;
  final Function(ObjectComponent object) openEditor;
  final ObjectComponent Function()  addGameObject;
  final Function(ObjectComponent object) updateObject;
  final Function(ObjectComponent object) removeGameObject;
  final Function getSelectedObject;
  final Function getObjects;
  final Function() testGame;
  final Function() goBack;
  final Function(List<ObjectComponent> ) openObjects;
  final Function(Function(GameObject), Function(GameObject)) openAssets;
  final Function(GameObject) spawnAsset;
  final Function(GameObject) updateAsset;

  BottomBarCallbacks({
    required this.selectObject,
    required this.openEditor,
    required this.addGameObject,
    required this.updateObject,
    required this.removeGameObject,
    required this.getSelectedObject,
    required this.getObjects,
    required this.testGame,
    required this.goBack,
    required this.openObjects,
    required this.openAssets,
    required this.spawnAsset,
    required this.updateAsset,
  });
}