import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_callbacks.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

/// The bottom bar of the editor.
///
/// Contains buttons to add, delete, edit, upload, ...
class BottomBarComponent extends PositionComponent {
  /// The size of the screen.
  final Vector2 screenSize;

  /// All the bottom bar callbacks
  final BottomBarCallbacks bottomBarCallbacks;

  /// The button to add an object.
  late BottomBarbuttonComponent addBtn;
  /// The button to delete an object.
  late BottomBarbuttonComponent deleteBtn;
  /// The button to edit an object.
  late BottomBarbuttonComponent editBtn;
  /// The button to upload the game.
  late BottomBarbuttonComponent uploadBtn;

  /// The SVG instance.
  ///
  /// Used to load the SVG files.
  late Svg svgInstance;

  BottomBarComponent({
    required this.screenSize,
    required this.bottomBarCallbacks,
  });

  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomLeft;

    // Set the position of the bottom bar
    position = Vector2(0, screenSize.y - 50);
    super.onLoad();

    // Create the background
    final background = RectangleComponent(
        size: Vector2(screenSize.x, 50),
        position: Vector2(0, 0),
        paint: Paint()..color = const Color(0xFF000000));

    // Create the buttons
    addBtn =
        BottomBarbuttonComponent('svg/add.svg', Vector2(0, 0), tapAction: () {
          var newObject = bottomBarCallbacks.addGameObject();
    });

    deleteBtn = BottomBarbuttonComponent('svg/delete.svg', Vector2(60, 0),
        tapAction: () {
          bottomBarCallbacks.removeGameObject(bottomBarCallbacks.getSelectedObject());
    });

    editBtn = BottomBarbuttonComponent('svg/edit.svg', Vector2(120, 0),
        tapAction: () {
          bottomBarCallbacks.openEditor(bottomBarCallbacks.getSelectedObject());
    });

    uploadBtn = BottomBarbuttonComponent('svg/upload.svg', Vector2(300, 0),
        tapAction: () {
          bottomBarCallbacks.uploadGame();
    });

    // Add the components to the bottom bar
    add(background);
    add(addBtn);
    add(deleteBtn);
    add(editBtn);
    add(uploadBtn);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Update the buttons depending on the selected object
    if (deleteBtn != null && editBtn != null) {
      if (bottomBarCallbacks.getSelectedObject() == null) {
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
