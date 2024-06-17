import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_flame/component_flame_rect.dart';
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
  ComponentType instance() {
    ComponentRect comp = ComponentRect();
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
    Vector2 size = Vector2(
      fields["width"]!.value.toDouble(),
      fields["height"]!.value.toDouble(),
    );

    RectangleComponent display = ComponentFlameRect(
      size: size,
      position: Vector2(0, 0),
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragStartCallback: onDragStartCallback,
      onDragUpdateCallback: onDragUpdateCallback
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

  @override
  ShapeComponent? getGameDisplayComponent() {
    Vector2 size = Vector2(
      fields["width"]!.value.toDouble(),
      fields["height"]!.value.toDouble(),
    );

    print('size: $size');

    return RectangleComponent(
      size: size,
      position: Vector2(0, 0),
    );
  }
}
