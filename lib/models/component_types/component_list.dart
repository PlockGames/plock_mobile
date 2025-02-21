import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../component_fields/component_field_color.dart';
import '../component_fields/component_field_list.dart';
import '../component_flame/component_flame_text.dart';
import '../games/component_type.dart';
import '../games/media.dart';

/// A component that contain an object level variable
class ComponentList extends ComponentType {

  ComponentList() {
    fields["name"] = ComponentFieldText(value: "my_list");
    fields["values"] = ComponentFieldList(value: []);
  }

  @override
  String get type => 'ComponentList';

  @override
  String get name => 'List';

  @override
  ComponentType instance() {
    ComponentList comp = ComponentList();
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
    return DisplayComponents(display: null, select: null);
  }

  @override
  Component? getGameDisplayComponent(
      List<Media> medias,
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {
    return null;
  }
}
