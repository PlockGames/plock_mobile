import 'package:plock_mobile/models/games/component_field.dart';

class ComponentType {
  Map<String, ComponentField> fields = Map<String, ComponentField>.identity();

  ComponentType();

  String get type => 'Component';
  String get name => 'Rectangle';

  ComponentType instance() {
    ComponentType comp = ComponentType();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }
}
