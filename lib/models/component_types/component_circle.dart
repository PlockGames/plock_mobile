import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_flame/component_flame_circle.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../component_fields/component_field_color.dart';
import '../games/component_type.dart';

/// A component that display a circle.
class ComponentCircle extends ComponentType {
  ComponentCircle() {
    fields["radius"] = ComponentFieldNumber(value: 10);
    fields["color"] = ComponentFieldColour(value: Color(0xffffffff));
  }

  @override
  String get type => 'ComponentCircle';

  @override
  String get name => 'Circle';

  @override
  ComponentType instance() {
    ComponentCircle comp = ComponentCircle();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }

  @override
  DisplayComponents getDisplayComponent(
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback
      ) {
    double radius = fields["radius"]!.value.toDouble();
    Color color = fields["color"]!.value;

    CircleComponent display = ComponentFlameCircle(
      radius: radius,
      position: Vector2(-radius, -radius),
      color: color,
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragStartCallback: onDragStartCallback,
      onDragUpdateCallback: onDragUpdateCallback
    );

    CircleComponent select = CircleComponent(
      radius: radius,
      position: Vector2(0, 0),
      paint: Paint()
        ..color = const Color(0x00F5D142)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    display.add(select);
    return DisplayComponents(display: display, select: select);
  }

  @override
  Component? getGameDisplayComponent() {
    double radius = fields["radius"]!.value.toDouble();
    Color color = fields["color"]!.value;

    return CircleComponent(
      radius: radius,
      position: Vector2(-radius, -radius),
      paint: Paint()..color = color
    );
  }
}
