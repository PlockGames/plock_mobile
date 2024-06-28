import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

/// A bottom bar button.
///
/// Used in the [BottomBarComponent].
class BottomBarbuttonComponent extends PositionComponent with TapCallbacks {

  /// The path to the SVG file.
  final String svgPath;

  /// The action to perform when the button is tapped.
  final Function? tapAction;

  /// The SVG instance to load SVG files.
  late Svg svgInstance;

  BottomBarbuttonComponent(this.svgPath, Vector2 pos, {this.tapAction}) {
    position = pos;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(60, 60);

    svgInstance = await Svg.load(svgPath);
    final svgComponent = SvgComponent(
      svg: svgInstance,
      size: Vector2(60, 60),
      position: Vector2(0, 0),
    );

    add(svgComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
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
