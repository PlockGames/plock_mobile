import 'package:plock_mobile/models/component_types/component_variable.dart';

import '../models/component_types/component_circle.dart';
import '../models/component_types/component_rect.dart';
import '../models/component_types/component_text.dart';
import '../models/component_types/component_event.dart';
import '../models/component_types/component_gravity.dart';

import '../models/games/component_type.dart';

/**
 * ComponentList class
 *
 * This contain all the components that can be used in the game.
 */
class ComponentList {
  static final Map<String, ComponentType> components = {
    'ComponentRect': ComponentRect(),
    'ComponentCircle': ComponentCircle(),
    'ComponentText': ComponentText(),
    'ComponentEvent': ComponentEvent(),
    'ComponentVariable': ComponentVariable(),
    'ComponentGravity': ComponentGravity(),
  };

  static get() {
    return components;
  }

  static getByName(String name) {
    return components[name];
  }
}