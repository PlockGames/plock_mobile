import 'dart:convert';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/display_components.dart';

class ComponentType {
  Map<String, ComponentField> fields = Map<String, ComponentField>.identity();

  ComponentType();

  String get type => 'Component';
  String get name => 'Unknown';

  ComponentType instance() {
    ComponentType comp = ComponentType();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }

  DisplayComponents getDisplayComponent(
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {
    return DisplayComponents();
  }

  void setOnUpdate(onUpdate) {
    fields.forEach((key, value) {
      value.onUpdate = onUpdate;
    });
  }

  String toJson() {
    var map = [];
    fields.forEach((key, value) {
      map.add({key: value.value});
    });

    String json = "";
    map.forEach((element) {
      json += "{\"" + element.keys.first + "\": " + element.values.first.toString() + "}";
      if (map.indexOf(element) != map.length - 1) {
        json += ",";
      }
    });

    return json;
  }
}
