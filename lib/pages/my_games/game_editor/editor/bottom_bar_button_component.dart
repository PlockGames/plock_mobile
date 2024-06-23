import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

class BottomBarbuttonComponent extends PositionComponent with TapCallbacks {
  final String svgPath;
  final tapAction;

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
    tapAction();
    return true;
  }
}
