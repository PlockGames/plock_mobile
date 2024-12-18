import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_flame/component_flame_rect.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../../pages/play/game_player_object.dart';
import '../component_fields/component_field_color.dart';
import '../games/component_type.dart';

/// A component that display a rectangle.
class ComponentRect extends ComponentType {
  ComponentRect() {
    fields["width"] = ComponentFieldNumber(value: 1.0);
    fields["height"] = ComponentFieldNumber(value: 1.0);
    fields["color"] = ComponentFieldColour(value: Color(0xffffffff));
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
      position: Vector2(0,0),
      color: fields["color"]!.value,
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragStartCallback: onDragStartCallback,
      onDragUpdateCallback: onDragUpdateCallback
    );

    RectangleComponent select = RectangleComponent(
      size: size * 20,
      scale: Vector2(0.05, 0.05),
      position: Vector2(0, 0),
      paint: Paint()
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = const Color(0x00F5D142)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.0,
    );

    display.add(select);
    return DisplayComponents(display: display, select: select);
  }

  @override
  Component? getGameDisplayComponent( onTapeUpCallback, onDragStartCallback, onDragUpdateCallback, onDragEndCallback, onDragCancelCallback) {
    Vector2 size = Vector2(
      fields["width"]!.value.toDouble(),
      fields["height"]!.value.toDouble(),
    );

    return ComponentFlameRect(
      size: size,
      color: fields["color"]!.value,
      position: Vector2(0, 0),
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragStartCallback: onDragStartCallback,
      onDragUpdateCallback: onDragUpdateCallback,
      componentType: this
    );
  }

  @override
  GamePlayerObject updateDisplay(Component? component, GamePlayerObject parent) {
    if (component is ComponentFlameRect) {
      component.width = fields["width"]!.value.toDouble();
      component.height = fields["height"]!.value.toDouble();
      component.paint = Paint()..color = fields["color"]!.value;
      component.x = -component.width / 2;
      component.y = -component.height / 2;
    }
    return parent;
  }

}
