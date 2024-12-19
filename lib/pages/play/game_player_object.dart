import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';
import 'package:flutter_js/flutter_js.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

/// A flame object that represents a game object in te game engine.
class GamePlayerObject extends BodyComponent with ContactCallbacks {

  /// The game object linked to this Flame object.
  late GameObject gameObject;

  /// The game data.
  late Game plockGame;

  /// List of all the components that can be displayed.
  List<Component> displayComponents = [];

  /// List of all the events components.
  List<ComponentType> eventComponents = [];

  /// Lua state, used to execute events.
  LuaState lua = LuaState.newState();

  /// js state, used to execute events.
  JavascriptRuntime js = getJavascriptRuntime();

  List<Contact> contacts = [];

  GamePlayerObject({
    required this.gameObject,
    required this.plockGame,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Set the object data
    renderBody = false;

    // get object size
    double width = 0;
    double height = 0;
    for (var component in gameObject.components) {
      if (component.type == 'ComponentPhysics') {
        width = component.fields['width']!.value;
        height = component.fields['height']!.value;
      }
    }

    bodyDef = BodyDef()
      ..position = Vector2(gameObject.position.x, gameObject.position.y)
      ..type = BodyType.static
      ..userData = this;

    fixtureDefs = [
      FixtureDef(
        PolygonShape()
          ..setAsBoxXY((width / 2), (height / 2)),
        density: 1.0,
        friction: 0.3,
      ),
    ];

    //await lua.openLibs();
    EventManager.registerEvents(js, plockGame, gameObject.id);

    // Update the components
    gameObject.isPhysicsDirty = false;
    updateDisplay();
    updateEvents();

    // Execute the start events
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_START') {
        executeEvent(component.fields['event']!.value[0], "");
      }
    }

  }

  /// Update the display components.
  void updateDisplay() {
    List<ComponentType> alreadyDisplayed = [];

    // Update the components that are already instancied
    for (var component in this.children) {
      if (component is ComponentFlame) {
        ComponentFlame componentFlame = component as ComponentFlame;
        if (componentFlame.getComponentType() == null) {
          continue;
        }
        ComponentType componentType = componentFlame.getComponentType()!;
        this.bodyDef = componentType.updateDisplay(component, this).bodyDef;
        alreadyDisplayed.add(componentFlame.getComponentType()!);
      }
    }

    // Add the new components
    for (var component in gameObject.components) {
        if (!alreadyDisplayed.contains(component)) {
          Component? comp = component.getGameDisplayComponent(
            onTapUp,
            onDragStart,
            onDragUpdate,
            onDragEnd,
            onDragCancel);
          if (comp != null) {
            add(comp);
            ComponentFlame componentFlame = comp as ComponentFlame;
            if (componentFlame.getComponentType() == null) {
              continue;
            }
            ComponentType componentType = componentFlame.getComponentType()!;
            this.bodyDef = componentType.updateDisplay(comp, this).bodyDef;
          }
        }
    }

    if (gameObject.force != null) {
      body.applyForce(Vector2(gameObject.force!.x, gameObject.force!.y));
      gameObject.force = null;
    }

  }

  void updatePhysic() {
    if (gameObject.isPhysicsDirty && body.isAwake) {
      gameObject.isPhysicsDirty = false;
      Vector2 oldPos = this.body.position;
      if (gameObject.isPositionDirty) {
        oldPos = Vector2(gameObject.position.x, gameObject.position.y);
        gameObject.isPositionDirty = false;
      }
      world.destroyBody(body);
      bodyDef!.position = oldPos;
      this.body = world.createBody(bodyDef!);
      for (var fixtureDef in fixtureDefs!) {
        body.createFixture(fixtureDef);
      }
    } else {
      if (gameObject.isPositionDirty) {
        gameObject.isPositionDirty = false;
        body.transform.setFrom(Transform.from(Vector2(gameObject.position.x, gameObject.position.y), Rot()));
      }
    }
  }

  /// Update the event components list.
  void updateEvents() {
    eventComponents = [];
    for (var component in gameObject.components) {
      if (component.type == 'ComponentEvent') {
        eventComponents.add(component);
      }
    }
  }

  /// Update the object data.
  void updateObjectData() {
    bodyDef?.position = Vector2(gameObject.position.x, gameObject.position.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_UPDATE') {

        executeEvent(component.fields['event']!.value[0], "");
      }
    }

    for (var contact in contacts) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_COLLISION') {
          executeEvent(component.fields['event']!.value[0], "");
        }
      }
    }
    contacts = [];

  }

  bool onTapUp(TapUpEvent info) {
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_TAP') {
        plockGame.lastTouchPosition = Vector2(info.localPosition.x, info.localPosition.y);
        executeEvent(component.fields['event']!.value[0], "");
      }
    }
    return true;
  }

  void onDragStart(DragStartEvent event) {
  }

  void onDragUpdate(DragUpdateEvent event) {
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_DRAG') {
        double x = event.canvasStartPosition.x + event.canvasDelta.x;
        double y = event.canvasStartPosition.y + event.canvasDelta.y;
        plockGame.lastTouchPosition = Vector2(x, y);
        executeEvent(component.fields['event']!.value[0], "");
      }
    }
  }

  void onDragEnd(DragEndEvent event) {
  }

  void onDragCancel(DragCancelEvent event) {
  }

  /// Execute an event.
  Future<void> executeEvent(String event, String collider) async {
    // add collider to the event
    event = "let collider = \"${collider}\"\n" + event;

    JsEvalResult res = js.evaluate(event);

    if (res.rawResult != null) {
      print(event);
      print(res);
    }
  }

  void stopEvents() {
    try {
      lua.error();
    } catch (e) {
      print("Game interrupted");
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    if (other is GamePlayerObject) {
      contacts.add(contact);
    }
  }
}

