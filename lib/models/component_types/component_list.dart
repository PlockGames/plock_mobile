// ignore: unused_import
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../component_fields/component_field_list.dart';
import '../games/component_type.dart';
import '../games/media.dart';

/// A component that contain an object level list
class ComponentList extends ComponentType {

  ComponentList() {
    fields["name"] = ComponentFieldText(value: "my_list");
    fields["values"] = ComponentFieldList(value: []);
  }

  /// The name of the type of component.
  @override
  String get type => 'ComponentList';

  /// The display name of the component.
  @override
  String get name => 'List';

  /// Return a copy of the component.
  @override
  ComponentType instance() {
    ComponentList comp = ComponentList();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }

  /// Return the flame component to display the component in the editor.
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

  /// Return the flame component to display the component in the game.
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

  /// Return the flame component to display the component in the game.
  @override
  bool get isScrollable => true;
}
