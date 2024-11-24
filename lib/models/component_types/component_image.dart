import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_flame/component_flame_image.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import '../component_fields/component_field_number.dart';
import '../component_fields/component_field_texture.dart';
import '../games/component_type.dart';

/// A component that contain an object level variable
class ComponentImage extends ComponentType {

  ComponentImage() {
    fields["size"] = ComponentFieldNumber(value: 1.0);
    fields["texture"] = ComponentFieldTexture(value: null);
  }

  @override
  String get type => 'ComponentVariable';

  @override
  String get name => 'Image';

  @override
  ComponentType instance() {
    ComponentImage comp = ComponentImage();
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

    ComponentFlameImage display = ComponentFlameImage(
      onDragStartCallback: onDragStartCallback,
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragUpdateCallback: onDragUpdateCallback,
      image: fields["texture"]!.value,
      initScale: Vector2(fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
      componentType: this
    );

    return DisplayComponents(display: display, select: null);
  }

  @override
  Component? getGameDisplayComponent(
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {
    return null;
  }
}
