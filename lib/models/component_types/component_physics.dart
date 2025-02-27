import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plock_mobile/models/component_fields/component_field_bool.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_flame/component_flame_empty.dart';
import 'package:plock_mobile/models/games/display_components.dart';

import '../../pages/play/game_player_object.dart';
import '../games/component_type.dart';
import '../games/media.dart';

/// A component that display a rectangle.
class ComponentPhysics extends ComponentType {
  ComponentPhysics() {
    fields["width"] = ComponentFieldNumber(value: 1.0);
    fields["height"] = ComponentFieldNumber(value: 1.0);
    fields["gravity"] = ComponentFieldNumber(value: 10.0);
    fields["lock rotation"] = ComponentFieldBool(value: false);
    fields["lock move X"] = ComponentFieldBool(value: false);
    fields["lock move Y"] = ComponentFieldBool(value: false);
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
  DisplayComponents getDisplayComponent(
      List<Media> medias,
      onTapeUpCallback, onDragStartCallback,
      onDragUpdateCallback, onDragEndCallback, onDragCancelCallback) {
    return DisplayComponents(display: null, select: null);
  }

  @override
  Component? getGameDisplayComponent(List<Media> medias,onTapeUpCallback, onDragStartCallback,
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
  Future<GamePlayerObject> updateDisplay(Component? component, GamePlayerObject parent) async {
      String type = fields["type"]!.value.toString();
      double gravity = fields["gravity"]!.value.toDouble();
      BodyType bodyType = BodyType.static;

      if (type == "dynamic") {
        bodyType = BodyType.dynamic;
      } else if (type == "kinematic") {
        bodyType = BodyType.kinematic;
      }

      parent.bodyDef!.gravityScale = Vector2(0, gravity);

      // if lock rotation is true
      if (parent.bodyDef!.fixedRotation != fields["lock rotation"]!.value) {
        parent.bodyDef!.fixedRotation = fields["lock rotation"]!.value;
        parent.lockRotationValue = parent.angle;
        parent.lockRotation = fields["lock rotation"]!.value;

        if (parent.bodyDef!.fixedRotation) {
          parent.bodyDef!.angularDamping = 0;

        } else {
          parent.bodyDef!.angularDamping = 0.1;
        }

        parent.gameObject.isPhysicsDirty = true;
      }

      if (parent.lockX != fields["lock move X"]!.value) {
        parent.lockX = fields["lock move X"]!.value;
        parent.lockXPosition = parent.position.x;
        parent.gameObject.isPhysicsDirty = true;
      }

      if (parent.lockY != fields["lock move Y"]!.value) {
        parent.lockY = fields["lock move Y"]!.value;
        parent.lockYPosition = parent.position.y;
        parent.gameObject.isPhysicsDirty = true;
      }

      if (parent.bodyDef!.type != bodyType) {
        parent.bodyDef!.type = bodyType;
        parent.gameObject.isPhysicsDirty = true;
      }

      parent.renderBody = false;

      return parent;
  }
}
