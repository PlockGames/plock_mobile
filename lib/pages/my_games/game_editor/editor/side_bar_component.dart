import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/models/flame/RoundedRectangleComponent.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_callbacks.dart';

import '../../../../models/games/game_object.dart';
import 'editor_canvas.dart';

/// The bottom bar of the editor.
///
/// Contains buttons to add, delete, edit, upload, ...
class SideBarComponent extends PositionComponent {
  /// The size of the screen.
  final Vector2 screenSize;

  /// All the bottom bar callbacks
  final BottomBarCallbacks bottomBarCallbacks;

  /// The background of the side bar.
  late RoundedRectangleComponent background;

  /// The button to delete an object.
  late BottomBarbuttonComponent deleteBtn;
  /// The button to edit an object.
  late BottomBarbuttonComponent editBtn;

  /// The SVG instance.
  ///
  /// Used to load the SVG files.
  late Svg svgInstance;

  /// The constructor.
  SideBarComponent({
    required this.screenSize,
    required this.bottomBarCallbacks,
  }) {
    priority = 10000;
  }

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topLeft;

    // Set the position of the bottom bar
    position = Vector2(0, 100);
    super.onLoad();

    // Create the background with a rounded border
    background = RoundedRectangleComponent(
      width: 60,
      height: 50 * 2,
      radius: 10,
      position: Vector2(-10, 0),
      paint: Paint()
        ..color = const Color.fromARGB(100, 0, 0, 0)
        ..style = PaintingStyle.fill,
    );

    // Create the buttons
    const iconSize = 40.0;

    // aligned left

    deleteBtn = BottomBarbuttonComponent('svg/delete.svg', Vector2(5, 0),
        tapAction: () {
          if (bottomBarCallbacks.getCanvas() == EditorCanvas.ui) {
            bottomBarCallbacks.removeUIObject(bottomBarCallbacks.getSelectedObject());
          } else {
            bottomBarCallbacks.removeGameObject(bottomBarCallbacks.getSelectedObject());
          }
    });

    editBtn = BottomBarbuttonComponent('svg/edit.svg', Vector2(5, iconSize),
        tapAction: () {
          if (bottomBarCallbacks.getCanvas() == EditorCanvas.ui) {
            List<dynamic> objects = bottomBarCallbacks.getUiObjects().map((e) => e.gameObject).toList();
            List<GameObject> gameObjects = objects.cast<GameObject>();
            bottomBarCallbacks.openEditor(bottomBarCallbacks.getSelectedObject(), gameObjects, EditorCanvas.ui);
          } else {
            List<dynamic> objects = bottomBarCallbacks.getObjects().map((e) =>
            e.gameObject).toList();
            List<GameObject> gameObjects = objects.cast<GameObject>();
            bottomBarCallbacks.openEditor(
                bottomBarCallbacks.getSelectedObject(), gameObjects, EditorCanvas.scene);
          }
    });

    // Add the components to the bottom bar
    add(background);
    add(deleteBtn);
    add(editBtn);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Update the buttons depending on the selected object
    if (bottomBarCallbacks.getSelectedObject() == null) {
      if (children.contains(deleteBtn)) {
        children.remove(deleteBtn);
      }
      if (children.contains(editBtn)) {
        children.remove(editBtn);
      }
      if (children.contains(background)) {
        children.remove(background);
      }
    } else {
      if (!children.contains(deleteBtn)) {
        add(deleteBtn);
      }
      if (!children.contains(editBtn)) {
        add(editBtn);
      }
      if (!children.contains(background)) {
        add(background);
      }
    }

  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
