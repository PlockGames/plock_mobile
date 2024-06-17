import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../../../../models/games/game.dart' as Plock;
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

class Editor extends FlameGame {
  ObjectComponent? selectedObject;

  // Callback to update the game
  final openEditor;
  final addGameObject;
  final removeGameObject;
  final updateGameObject;
  final uploadGame;

  final Plock.Game game;
  late TextComponent selectedObjectName;

  Editor({
    required this.openEditor,
    required this.game,
    required this.addGameObject,
    required this.removeGameObject,
    required this.updateGameObject,
    required this.uploadGame,
  });

  selectObject(ObjectComponent? object) {
    selectedObject = object;
  }

  isObjectSelected(ObjectComponent object) {
    return selectedObject == object;
  }

  updateObject(ObjectComponent object) {
    updateGameObject(object.gameObject);
    object.updateDisplay();
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF858585);
  }

  @override
  void onLoad() {
    super.onLoad();
    final objectContainer = PositionComponent();
    final bottomBar = BottomBarComponent(
        screenSize: size,
        objectContainer: objectContainer,
        selectObject: selectObject,
        isObjectSelected: isObjectSelected,
        openEditor: openEditor,
        addGameObject: addGameObject,
        updateObject: updateObject,
        deleteGameObject: removeGameObject,
        uploadGame: uploadGame
    );
    selectedObjectName = TextComponent()
      ..text = selectedObject?.name ?? ''
      ..anchor = Anchor.topLeft
      ..position = Vector2(10, size.y - 90);

    add(objectContainer);
    add(bottomBar);
    add(selectedObjectName);

    game.objects.forEach((element) {
      add(ObjectComponent(selectObject: selectObject, isObjectSelected: isObjectSelected, gameObject: element, updateObject: updateObject));
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    selectedObjectName.text = selectedObject?.name ?? '';
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
