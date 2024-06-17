import '../models/component_types/component_circle.dart';
import '../models/component_types/component_rect.dart';
import '../models/component_types/component_text.dart';
import '../models/games/component_type.dart';

class ComponentList {
  static final Map<String, ComponentType> components = {
    'ComponentRect': ComponentRect(),
    'ComponentCircle': ComponentCircle(),
    'ComponentText': ComponentText()
  };

  static get() {
    return components;
  }

  static getByName(String name) {
    return components[name];
  }
}