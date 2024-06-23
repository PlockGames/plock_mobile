import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

class BottomBarComponent extends PositionComponent {
  final Vector2 screenSize;
  final Component objectContainer;
  final selectObject;
  final isObjectSelected;
  final openEditor;
  final addGameObject;
  final updateObject;
  final deleteGameObject;
  final uploadGame;

  late BottomBarbuttonComponent addBtn;
  late BottomBarbuttonComponent deleteBtn;
  late BottomBarbuttonComponent editBtn;
  late BottomBarbuttonComponent uploadBtn;

  late Svg svgInstance;

  BottomBarComponent({
    required this.screenSize,
    required this.objectContainer,
    required this.selectObject,
    required this.isObjectSelected,
    required this.openEditor,
    required this.addGameObject,
    required this.updateObject,
    required this.deleteGameObject,
    required this.uploadGame,
  });

  selectedObject() {
    for (final component in objectContainer.children) {
      if (isObjectSelected(component)) {
        return component;
      }
    }
    return null;
  }

  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomLeft;

    position = Vector2(0, screenSize.y - 50);
    super.onLoad();

    final background = RectangleComponent(
        size: Vector2(screenSize.x, 50),
        position: Vector2(0, 0),
        paint: Paint()..color = const Color(0xFF000000));

    addBtn =
        BottomBarbuttonComponent('svg/add.svg', Vector2(0, 0), tapAction: () {
          var newObject = ObjectComponent(selectObject: selectObject, isObjectSelected: isObjectSelected, updateObject: updateObject);
          objectContainer.add(newObject);
          addGameObject(newObject.gameObject);
    });

    deleteBtn = BottomBarbuttonComponent('svg/delete.svg', Vector2(60, 0),
        tapAction: () {
          objectContainer.remove(selectedObject());
    });

    editBtn = BottomBarbuttonComponent('svg/edit.svg', Vector2(120, 0),
        tapAction: () {
      openEditor(selectedObject());
    });

    uploadBtn = BottomBarbuttonComponent('svg/upload.svg', Vector2(300, 0),
        tapAction: () {
        uploadGame();
    });

    add(background);
    add(addBtn);
    add(deleteBtn);
    add(editBtn);
    add(uploadBtn);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (deleteBtn != null && editBtn != null) {
      if (selectedObject() == null) {
        if (children.contains(deleteBtn)) {
          children.remove(deleteBtn);
        }
        if (children.contains(editBtn)) {
          children.remove(editBtn);
        }
      } else {
        if (!children.contains(deleteBtn)) {
          add(deleteBtn);
        }
        if (!children.contains(editBtn)) {
          add(editBtn);
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
