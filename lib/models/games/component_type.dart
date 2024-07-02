import 'dart:convert';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/display_components.dart';

/// A component that can be added to a game object.
class ComponentType {
  /// The fields (or values) of the component.
  Map<String, ComponentField> fields = Map<String, ComponentField>.identity();

  ComponentType();

  /// The type of the component.
  String get type => 'Component';

  /// The display name of the component.
  String get name => 'Unknown';

  /// Return a copy of the component.
  ComponentType instance() {
    ComponentType comp = ComponentType();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }

  /// Return the flame component to display the component in the editor.
  DisplayComponents getDisplayComponent(
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {
    return DisplayComponents();
  }

  /// Return the flame component to display the component in the game.
  Component? getGameDisplayComponent(
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {
    return null;
  }

  void updateDisplay(Component? component) {

  }

  /// Set a function executed when the component is updated.
  void setOnUpdate(onUpdate) {
    fields.forEach((key, value) {
      value.onUpdate = onUpdate;
    });
  }

  /// Convert the component to a JSON string.
  String toJson() {
    var map = [];
    fields.forEach((key, value) {
      map.add({key: value.toJson()});
    });

    String json = "{\"type\": \"" + type + "\", ";
    map.forEach((element) {
      json += "\"" + element.keys.first + "\": " + element.values.first;
      if (map.indexOf(element) != map.length - 1) {
        json += ",";
      }
    });
    json += "}";

    return json;
  }
}
