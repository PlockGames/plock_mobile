import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

import 'editor_canvas.dart';

/// A bottom bar button.
///
/// Used in the [BottomBarComponent].
class BottomBarButtonCanvasComponent extends PositionComponent
    with TapCallbacks {
  /// The path to the SVG file.
  var svgPathes = Map<EditorCanvas, String>.from({
    EditorCanvas.scene: 'svg/scene.svg',
    EditorCanvas.ui: 'svg/ui.svg',
  });

  /// The action to perform when the button is tapped.
  final Function? tapAction;

  /// The function to get the current canvas.
  final Function getCanvas;

  /// The SVG instance to load SVG files.
  late Map<EditorCanvas, Svg> svgInstances = <EditorCanvas, Svg>{};

  /// the svg component
  late SvgComponent svgComponent;

  BottomBarButtonCanvasComponent(Vector2 pos,
      {required this.getCanvas, this.tapAction}) {
    priority = 10000;
    position = pos;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(40, 40);

    for (var canvas in EditorCanvas.values) {
      svgInstances[canvas] = await Svg.load(svgPathes[canvas]!);
    }

    svgComponent = SvgComponent(
      svg: svgInstances[EditorCanvas.scene]!,
      size: Vector2(40, 40),
      position: Vector2(0, 10),
    );

    add(svgComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (getCanvas() == EditorCanvas.scene) {
      svgComponent.svg = svgInstances[EditorCanvas.scene]!;
    } else {
      svgComponent.svg = svgInstances[EditorCanvas.ui]!;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  bool onTapUp(TapUpEvent info) {
    if (tapAction != null) {
      tapAction!();
    }
    return true;
  }
}
