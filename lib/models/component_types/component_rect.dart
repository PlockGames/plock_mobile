import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../games/component_type.dart';

class ComponentRect extends ComponentType {
  ComponentRect() {
    fields["width"] = ComponentFieldNumber(value: 50);
    fields["height"] = ComponentFieldNumber(value: 50);
  }

  @override
  String get type => 'ComponentRect';

  @override
  String get name => 'Rectangle';

  @override
  DisplayComponents getDisplayComponent() {
    Vector2 size = Vector2(
      fields["width"]!.value.toDouble(),
      fields["height"]!.value.toDouble(),
    );

    RectangleComponent display = RectangleComponent(
      size: size,
      position: Vector2(0, 0),
    );

    RectangleComponent select = RectangleComponent(
      size: size,
      position: Vector2(0, 0),
      paint: Paint()
        ..color = const Color(0x00F5D142)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    display.add(select);
    return DisplayComponents(display: display, select: select);
  }
}
