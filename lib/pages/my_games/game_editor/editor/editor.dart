import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/flame_object.dart';

class Editor extends FlameGame {
  ObjectComponent? selectedObject;
  final openEditor;

  late TextComponent selectedObjectName;

  Editor(this.openEditor) {}

  selectObject(ObjectComponent? object) {
    selectedObject = object;
  }

  isObjectSelected(ObjectComponent object) {
    return selectedObject == object;
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
        size, objectContainer, selectObject, isObjectSelected, openEditor);
    selectedObjectName = TextComponent()
      ..text = selectedObject?.name ?? ''
      ..anchor = Anchor.topLeft
      ..position = Vector2(10, size.y - 90);

    add(objectContainer);
    add(bottomBar);
    add(selectedObjectName);
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
