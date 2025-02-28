import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_mode_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_callbacks.dart';

import '../../../../models/games/game_object.dart';
import 'bottom_bar_button_canvas_component.dart';
import 'editor_canvas.dart';

/// The bottom bar of the editor.
///
/// Contains buttons to add, delete, edit, upload, ...
class BottomBarComponent extends PositionComponent {
  /// The size of the screen.
  final Vector2 screenSize;

  /// All the bottom bar callbacks
  final BottomBarCallbacks bottomBarCallbacks;

  /// The button to change mode.
  late BottomBarbuttonModeComponent modeBtn;
  /// The button to change canvas.
  late BottomBarButtonCanvasComponent canvasBtn;
  /// The button to add an object.
  late BottomBarbuttonComponent addBtn;
  /// The button to upload the game.
  late BottomBarbuttonComponent uploadBtn;
  /// The button to access all the objects.
  late BottomBarbuttonComponent objectsBtn;
  /// the button to access all the assets.
  late BottomBarbuttonComponent assetsBtn;
  /// the button to access all medias
  late BottomBarbuttonComponent mediasBtn;

  /// The SVG instance.
  ///
  /// Used to load the SVG files.
  late Svg svgInstance;

  /// The constructor.
  BottomBarComponent({
    required this.screenSize,
    required this.bottomBarCallbacks,
  }) {
    priority = 10000;
  }

  @override
  Future<void> onLoad() async {
    anchor = Anchor.bottomLeft;

    // Set the position of the bottom bar
    position = Vector2(0, screenSize.y - 50);
    super.onLoad();

    // Create the background
    final background = RectangleComponent(
        priority: 10000,
        size: Vector2(screenSize.x, 50),
        position: Vector2(0, 0),
        paint: Paint()..color = const Color(0xFF000000));

    // Create the buttons
    const iconWidth = 40.0;

    // aligned left
    modeBtn = BottomBarbuttonModeComponent(Vector2(0, 0), getMode: bottomBarCallbacks.getMode, tapAction: () {
      bottomBarCallbacks.changeMode();
    });

    addBtn =
        BottomBarbuttonComponent('svg/add.svg', Vector2(iconWidth, 0), tapAction: () {
          if (bottomBarCallbacks.getCanvas() == EditorCanvas.ui) {
            bottomBarCallbacks.addUIObject();
          } else {
            bottomBarCallbacks.addGameObject();
          }
    });

    // aligned right
    double screenWidth = screenSize.x;

    uploadBtn = BottomBarbuttonComponent('svg/upload.svg', Vector2(screenWidth - iconWidth, 0),
        tapAction: () {
          bottomBarCallbacks.testGame();
    });

    objectsBtn = BottomBarbuttonComponent('svg/objects.svg', Vector2(screenWidth - iconWidth * 2, 0),
        tapAction: () {
          if (bottomBarCallbacks.getCanvas() == EditorCanvas.ui) {
            bottomBarCallbacks.openObjects(bottomBarCallbacks.getUiObjects(), bottomBarCallbacks.getCanvas());
          } else {
            bottomBarCallbacks.openObjects(bottomBarCallbacks.getObjects(),
                bottomBarCallbacks.getCanvas());
          }
    });

    assetsBtn = BottomBarbuttonComponent('svg/assets.svg', Vector2(screenWidth - iconWidth * 3, 0),
        tapAction: () {
          bottomBarCallbacks.openAssets(bottomBarCallbacks.spawnAsset, bottomBarCallbacks.updateAsset, bottomBarCallbacks.getCanvas());
    });

    mediasBtn = BottomBarbuttonComponent('svg/folder.svg', Vector2(screenWidth - iconWidth * 4, 0),
        tapAction: () {
          bottomBarCallbacks.openMedias();
    });

    canvasBtn = BottomBarButtonCanvasComponent(Vector2(screenWidth - iconWidth * 5, 0), getCanvas: bottomBarCallbacks.getCanvas, tapAction: () {
      bottomBarCallbacks.changeCanvas();
    });

    // Add the components to the bottom bar
    add(background);
    add(modeBtn);
    add(addBtn);
    add(uploadBtn);
    add(objectsBtn);
    add(assetsBtn);
    add(mediasBtn);
    add(canvasBtn);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Update the buttons depending on the canvas
    if (bottomBarCallbacks.getCanvas() == EditorCanvas.ui) {
      if (children.contains(modeBtn)) {
        children.remove(modeBtn);
      }
    } else {
      if (!children.contains(modeBtn)) {
        add(modeBtn);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
