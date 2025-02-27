import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';

import 'object_component.dart';
import 'object_ui_component.dart';

class BottomBarCallbacks {
  final Function(ObjectComponent? object) selectObject;
  final Function(ObjectComponent object, List<GameObject> objects, EditorCanvas canvas) openEditor;
  final ObjectComponent Function()  addGameObject;
  final ObjectUiComponent Function() addUIObject;
  final Function(ObjectComponent object) updateObject;
  final Function(ObjectUiComponent object) updateUIObject;
  final Function(ObjectComponent object) removeGameObject;
  final Function(ObjectUiComponent object) removeUIObject;
  final Function getSelectedObject;
  final Function getObjects;
  final Function getUiObjects;
  final Function() testGame;
  final Function() goBack;
  final Function(List<ObjectComponent>, EditorCanvas canvas) openObjects;
  final Function(Function(GameObject), Function(GameObject), EditorCanvas canvas) openAssets;
  final Function(GameObject) spawnAsset;
  final Function(GameObject) updateAsset;
  final Function() openMedias;
  final Function() changeMode;
  final Function() getMode;
  final Function() getCanvas;
  final Function() changeCanvas;

  BottomBarCallbacks({
    required this.selectObject,
    required this.openEditor,
    required this.addGameObject,
    required this.addUIObject,
    required this.updateObject,
    required this.updateUIObject,
    required this.removeGameObject,
    required this.removeUIObject,
    required this.getSelectedObject,
    required this.getObjects,
    required this.getUiObjects,
    required this.testGame,
    required this.goBack,
    required this.openObjects,
    required this.openAssets,
    required this.spawnAsset,
    required this.updateAsset,
    required this.openMedias,
    required this.changeMode,
    required this.getMode,
    required this.getCanvas,
    required this.changeCanvas,
  });
}