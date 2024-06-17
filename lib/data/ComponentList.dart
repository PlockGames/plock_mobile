import '../models/component_types/component_rect.dart';
import '../models/games/component_type.dart';

class ComponentList {
  static final Map<String, ComponentType> components = {
    'ComponentRect': ComponentRect(),
  };

  static get() {
    return components;
  }

  static getByName(String name) {
    return components[name];
  }
}