import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/flame_object.dart';

class BottomBarComponent extends PositionComponent {
  final Vector2 screenSize;
  final Component objectContainer;
  final selectObject;
  final isObjectSelected;
  final openEditor;

  late BottomBarbuttonComponent addBtn;
  late BottomBarbuttonComponent deleteBtn;
  late BottomBarbuttonComponent editBtn;

  late Svg svgInstance;

  BottomBarComponent(this.screenSize, this.objectContainer, this.selectObject,
      this.isObjectSelected, this.openEditor);

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
      this.objectContainer.add(ObjectComponent(selectObject, isObjectSelected));
    });

    deleteBtn = BottomBarbuttonComponent('svg/delete.svg', Vector2(60, 0),
        tapAction: () {
      this.objectContainer.remove(selectedObject());
    });

    editBtn = BottomBarbuttonComponent('svg/edit.svg', Vector2(120, 0),
        tapAction: () {
      openEditor(selectedObject());
    });

    add(background);
    add(addBtn);
    add(deleteBtn);
    add(editBtn);
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
