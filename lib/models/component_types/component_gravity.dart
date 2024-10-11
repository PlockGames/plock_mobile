import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_flame/component_flame_rect.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../component_fields/component_field_number.dart';
import '../games/component_type.dart';

/// A component that simulates gravity on both x and y axes.
class ComponentGravity extends ComponentType {
  ComponentGravity() {
    // Default gravity values for x and y axes
    fields["gravityX"] = ComponentFieldNumber(value: 0.0); // No gravity on x-axis by default
    fields["gravityY"] = ComponentFieldNumber(value: 9.8); // Default gravity value on y-axis
  }

  @override
  String get type => 'ComponentGravity';

  @override
  String get name => 'Gravité';

  @override
  ComponentType instance() {
    ComponentGravity comp = ComponentGravity();
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
    Vector2 size = Vector2(50.0, 50.0); // Size for display purposes

    RectangleComponent display = ComponentFlameRect(
        size: size,
        position: Vector2(0, 0),
        color: const Color(0xFF00FF00), // Just a color for visual representation
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
  Component? getGameDisplayComponent( onTapeUpCallback, onDragStartCallback, onDragUpdateCallback, onDragEndCallback, onDragCancelCallback) {
    Vector2 size = Vector2(50.0, 50.0); // Size for display purposes

    return ComponentFlameRect(
        size: size,
        color: const Color(0xFF00FF00), // Just a color for visual representation
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
  void updateDisplay(Component? component) {
    if (component is ComponentFlameRect) {
      component.width = 50.0;
      component.height = 50.0;
      component.paint = Paint()..color = const Color(0xFF00FF00); // Color for visual representation
      component.x = -component.width / 2;
      component.y = -component.height / 2;
    }
  }

  void applyGravity(double deltaTime) {
    // Retrieve gravity values for x and y axes
    double gravityX = fields["gravityX"]!.value.toDouble();
    double gravityY = fields["gravityY"]!.value.toDouble();

    // Adjust the position of the component based on gravity and deltaTime
    // For example, if you're using Forge2D, you might apply a force to the body
    // Or you can manually adjust the position if you're not using physics
    // E.g., component.position.x += gravityX * deltaTime;
    //       component.position.y += gravityY * deltaTime;

    // Logic to apply gravity to a component, e.g., adjusting its position based on gravity values
  }
}
