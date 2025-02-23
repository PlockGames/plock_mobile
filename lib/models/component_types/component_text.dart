import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../../pages/play/game_player_object.dart';
import '../component_fields/component_field_color.dart';
import '../component_fields/component_field_number.dart';
import '../component_flame/component_flame_text.dart';
import '../games/component_type.dart';
import '../games/media.dart';

/// A component that display a text.
class ComponentText extends ComponentType {

  ComponentText() {
    fields["text"] = ComponentFieldText(value: "Text");
    fields["size"] = ComponentFieldNumber(value: 1.0);
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
      List<Media> medias,
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback
      ) {
    String text = fields["text"]!.value.toString();
    double size = fields["size"]!.value.toDouble();

    TextComponent display = ComponentFlameText(
      text: text,
      position: Vector2(0, 0),
      color: fields["color"]!.value,
      fontSize: size,
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragStartCallback: onDragStartCallback,
      onDragUpdateCallback: onDragUpdateCallback,
      componentType: this
    );

    RectangleComponent select = RectangleComponent(
      size: display.absoluteScaledSize * 20,
      scale: Vector2(0.05, 0.05),
      position: Vector2(0, 0),
      anchor: size < 1 ? Anchor.centerLeft : Anchor.topLeft,
      paint: Paint()
        ..color = const Color(0x00F5D142)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0,
    );

    display.add(select);
    return DisplayComponents(display: display, select: select);
  }

  @override
  Component? getGameDisplayComponent(
      List<Media> medias,
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback,) {
    String text = fields["text"]!.value.toString();
    double size = fields["size"]!.value.toDouble();


    return ComponentFlameText(
      text: text,
      position: Vector2(0, 0),
      color: fields["color"]!.value,
      fontSize: size,
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragStartCallback: onDragStartCallback,
      onDragUpdateCallback: onDragUpdateCallback,
      componentType: this
    );
  }

  @override
  Future<GamePlayerObject> updateDisplay(Component? component, GamePlayerObject parent) async {
    if (component is ComponentFlameText) {
      component.text = fields["text"]!.value;
      component.textRenderer = TextPaint(
        style: TextStyle(
          color: fields["color"]!.value,
        ),
      );
    }
    return parent;
  }

}
