import 'package:plock_mobile/models/games/game_object.dart';

import 'object_component.dart';

class EditorCallbacks {
  final Function(ObjectComponent object) openEditor;
  final Function(GameObject gameObject) addGameObject;
  final Function(GameObject gameObject) removeGameObject;
  final Function(GameObject gameObject) updateGameObject;
  final Function() testGame;
  final Function() goBack;
  final Function(List<ObjectComponent>) openObjects;
  final Function(Function(GameObject), Function(GameObject)) openAssets;

  EditorCallbacks({
    required this.openEditor,
    required this.addGameObject,
    required this.removeGameObject,
    required this.updateGameObject,
    required this.testGame,
    required this.goBack,
    required this.openObjects,
    required this.openAssets,
  });
}