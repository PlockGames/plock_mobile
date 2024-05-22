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
}
