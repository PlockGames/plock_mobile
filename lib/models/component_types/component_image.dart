import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import '../component_fields/component_field_texture.dart';
import '../games/component_type.dart';

/// A component that contain an object level variable
class ComponentImage extends ComponentType {

  ComponentImage() {
    fields["texture"] = ComponentFieldTexture(value: null);
  }

  @override
  String get type => 'ComponentVariable';

  @override
  String get name => 'Variable';

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
    return DisplayComponents(display: null, select: null);
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
