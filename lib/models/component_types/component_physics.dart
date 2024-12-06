import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_flame/component_flame_empty.dart';
import 'package:plock_mobile/models/component_flame/component_flame_rect.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../../pages/play/game_player_object.dart';
import '../component_fields/component_field_color.dart';
import '../games/component_type.dart';

/// A component that display a rectangle.
class ComponentPhysics extends ComponentType {
  ComponentPhysics() {
    fields["width"] = ComponentFieldNumber(value: 50.0);
    fields["height"] = ComponentFieldNumber(value: 50.0);
    fields["type"] = ComponentFieldDropDown(value: "static", options: {
      "static": "Static",
      "dynamic": "Dynamic",
      "kinematic": "Kinematic"
    });
  }

  @override
  String get type => 'ComponentPhysics';

  @override
  String get name => 'Physics';

  @override
  ComponentType instance() {
    ComponentPhysics comp = ComponentPhysics();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }

  @override
  DisplayComponents getDisplayComponent(onTapeUpCallback, onDragStartCallback,
      onDragUpdateCallback, onDragEndCallback, onDragCancelCallback) {
    return DisplayComponents(display: null, select: null);
  }

  @override
  Component? getGameDisplayComponent(onTapeUpCallback, onDragStartCallback,
      onDragUpdateCallback, onDragEndCallback, onDragCancelCallback) {

    return ComponentFlameEmpty(
      onDragStartCallback: onDragStartCallback,
      onTapeUpCallback: onTapeUpCallback,
      onDragCancelCallback: onDragCancelCallback,
      onDragEndCallback: onDragEndCallback,
      onDragUpdateCallback: onDragUpdateCallback,
      color: Color(0xffffffff),
      componentType: this
    );
  }

  @override
  GamePlayerObject updateDisplay(Component? component, GamePlayerObject parent) {
      String type = fields["type"]!.value.toString();
      BodyType bodyType = BodyType.static;

      print("Type: $type");
      if (type == "dynamic") {
        bodyType = BodyType.dynamic;
      } else if (type == "kinematic") {
        bodyType = BodyType.kinematic;
      }

      parent.bodyDef!.type = bodyType;
      parent.renderBody = false;
      return parent;
  }
}
