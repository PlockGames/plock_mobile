import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../component_fields/component_field_color.dart';
import '../component_flame/component_flame_text.dart';
import '../games/component_type.dart';

/// A component that contain an object level variable
class ComponentVariable extends ComponentType {

  ComponentVariable() {
    fields["name"] = ComponentFieldText(value: "my_variable");
    fields["value"] = ComponentFieldText(value: "0");
  }

  @override
  String get type => 'ComponentVariable';

  @override
  String get name => 'Variable';

  @override
  ComponentType instance() {
    ComponentVariable comp = ComponentVariable();
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
