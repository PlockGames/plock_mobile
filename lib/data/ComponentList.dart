import '../models/component_types/component_circle.dart';
import '../models/component_types/component_rect.dart';
import '../models/component_types/component_text.dart';
import '../models/component_types/component_event.dart';
import '../models/games/component_type.dart';

/// Contain all the components that can be used in the game.
class ComponentList {
  static final Map<String, ComponentType> components = {
    'ComponentRect': ComponentRect(),
    'ComponentCircle': ComponentCircle(),
    'ComponentText': ComponentText(),
    'ComponentEvent': ComponentEvent(),
  };

  static get() {
    return components;
  }

  static getByName(String name) {
    return components[name];
  }
}