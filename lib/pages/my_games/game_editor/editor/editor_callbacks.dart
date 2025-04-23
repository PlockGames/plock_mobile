import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';

import '../../../../models/games/scene.dart';
import 'object_component.dart';

class EditorCallbacks {
  final Function(ObjectComponent object, List<GameObject> objects, EditorCanvas canvas) openEditor;
  final Function(GameObject gameObject) addGameObject;
  final Function(GameObject gameObject) addUIObject;
  final Function(GameObject gameObject) removeGameObject;
  final Function(GameObject gameObject) removeUIObject;
  final Function(GameObject gameObject) updateGameObject;
  final Function(GameObject gameObject) updateUIObject;
  final Function() testGame;
  final Function() goBack;
  final Function(List<ObjectComponent>, EditorCanvas canvas) openObjects;
  final Function(Function(GameObject, EditorCanvas), Function(GameObject), EditorCanvas canvas) openAssets;
  final Function() openMedias;
  final Function(Function(Scene) changeScene) openScenes;

  EditorCallbacks({
    required this.openEditor,
    required this.addGameObject,
    required this.addUIObject,
    required this.removeGameObject,
    required this.removeUIObject,
    required this.updateGameObject,
    required this.updateUIObject,
    required this.testGame,
    required this.goBack,
    required this.openObjects,
    required this.openAssets,
    required this.openMedias,
    required this.openScenes,
  });
}