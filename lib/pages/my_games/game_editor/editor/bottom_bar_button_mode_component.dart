import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_mode.dart';

/// A bottom bar button.
///
/// Used in the [BottomBarComponent].
class BottomBarbuttonModeComponent extends PositionComponent with TapCallbacks {

  /// The path to the SVG file.
  var svgPathes = Map<EditorMode, String>.from({
    EditorMode.edit: 'svg/select.svg',
    EditorMode.move: 'svg/move.svg',
  });

  /// The action to perform when the button is tapped.
  final Function? tapAction;

  /// The function to get the current editor mode.
  final Function getMode;

  /// The SVG instance to load SVG files.
  late Map<EditorMode, Svg> svgInstances = <EditorMode, Svg>{};

  /// the svg component
  late SvgComponent svgComponent;

  BottomBarbuttonModeComponent(Vector2 pos, {required this.getMode, this.tapAction}) {
    position = pos;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(40, 40);

    for (var mode in EditorMode.values) {
      svgInstances[mode] = await Svg.load(svgPathes[mode]!);
    }
    print(svgInstances);
    svgComponent = SvgComponent(
      svg: svgInstances[EditorMode.edit]!,
      size: Vector2(40, 40),
      position: Vector2(0, 10),
    );

    add(svgComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (getMode() == EditorMode.edit) {
      svgComponent.svg = svgInstances[EditorMode.edit]!;
    } else {
      svgComponent.svg = svgInstances[EditorMode.move]!;
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
