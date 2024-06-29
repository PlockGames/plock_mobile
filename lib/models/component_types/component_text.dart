import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../component_fields/component_field_color.dart';
import '../component_flame/component_flame_text.dart';
import '../games/component_type.dart';

/// A component that display a text.
class ComponentText extends ComponentType {

  ComponentText() {
    fields["text"] = ComponentFieldText(value: "Text");
    fields["color"] = ComponentFieldColour(value: Color(0xffffffff));
  }

  @override
  String get type => 'ComponentText';

  @override
  String get name => 'Text';

  @override
  ComponentType instance() {
    ComponentText comp = ComponentText();
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
    String text = fields["text"]!.value.toString();

    TextComponent display = ComponentFlameText(
      text: text,
      position: Vector2(0, 0),
      color: fields["color"]!.value,
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragStartCallback: onDragStartCallback,
      onDragUpdateCallback: onDragUpdateCallback
    );

    RectangleComponent select = RectangleComponent(
      size: display.absoluteScaledSize,
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
    String text = fields["text"]!.value.toString();

    TextStyle style = TextStyle(
      color: fields["color"]!.value,
    );

    return TextComponent(
      text: text,
      position: Vector2(0, 0),
      textRenderer: TextPaint(
        style: style
      ),
    );
  }
}
