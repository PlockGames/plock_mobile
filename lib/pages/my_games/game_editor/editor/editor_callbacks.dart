import 'package:plock_mobile/models/games/game_object.dart';

import 'object_component.dart';

class EditorCallbacks {
  final Function(ObjectComponent object) openEditor;
  final Function(GameObject gameObject) addGameObject;
  final Function(GameObject gameObject) removeGameObject;
  final Function(GameObject gameObject) updateGameObject;
  final Function() uploadGame;
  final Function() goBack;

  EditorCallbacks({
    required this.openEditor,
    required this.addGameObject,
    required this.removeGameObject,
    required this.updateGameObject,
    required this.uploadGame,
    required this.goBack,
  });
}