import 'package:plock_mobile/models/component_types/component_image.dart';
import 'package:plock_mobile/models/component_types/component_tilemap.dart';
import 'package:plock_mobile/models/component_types/component_ui_text.dart';
import 'package:plock_mobile/models/component_types/component_variable.dart';

import '../models/component_types/component_circle.dart';
import '../models/component_types/component_physics.dart';
import '../models/component_types/component_rect.dart';
import '../models/component_types/component_sprite.dart';
import '../models/component_types/component_text.dart';
import '../models/component_types/component_event.dart';
import '../models/component_types/component_list.dart' as cp;
import '../models/games/component_type.dart';

/**
 * ComponentList class
 *
 * This contain all the components that can be used in the game.
 */
class ComponentList {
  static final Map<String, ComponentType> sceneComponents = {
    'ComponentRect': ComponentRect(),
    'ComponentCircle': ComponentCircle(),
    'ComponentText': ComponentText(),
    'ComponentEvent': ComponentEvent(),
    'ComponentVariable': ComponentVariable(),
    'ComponentList': cp.ComponentList(),
    'ComponentImage': ComponentImage(),
    'ComponentSprite': ComponentSprite(),
    'ComponentPhysics': ComponentPhysics(),
    'ComponentTilemap': ComponentTilemap(),
  };

  static final Map<String, ComponentType> uiComponents = {
    'ComponentUiText': ComponentUiText(),
    'ComponentVariable': ComponentVariable(),
    'ComponentList': cp.ComponentList(),
    'ComponentEvent': ComponentEvent(),
  };

  static Map<String, ComponentType> getScene() {
    return sceneComponents;
  }

  static Map<String, ComponentType> getUi() {
    return uiComponents;
  }

  static final Map<String, ComponentType> components = {
    ...sceneComponents,
    ...uiComponents,
  };

  static Map<String, ComponentType> getAll() {
    return components;
  }

  static getByName(String name) {
    return components[name];
  }
}