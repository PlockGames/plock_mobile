import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge2d;
import 'package:flutter_js_plus/flutter_js.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

/// A flame object that represents a game object in the game engine.
class GamePlayerObject extends forge2d.BodyComponent with forge2d.ContactCallbacks {

  /// The game object linked to this Flame object.
  late GameObject gameObject;

  /// The game data.
  final Game plockGame;

  /// List of all the components that can be displayed.
  List<Component> displayComponents = [];

  /// List of all the events components.
  List<ComponentType> eventComponents = [];

  /// js state, used to execute events.
  JavascriptRuntime js = getJavascriptRuntime();

  /// does the gameObject need to abort the event ?
  bool needAbort = false;

  /// A list of all untreated start contacts.
  List<forge2d.Contact> beginContacts = [];

  /// A list of all untreated end contacts.
  List<forge2d.Contact> endContacts = [];

  /// lock X position
  bool lockX = false;

  /// lock X position position
  double lockXPosition = 0;

  /// lock Y position
  bool lockY = false;

  /// lock Y position position
  double lockYPosition = 0;

  /// lock rotation
  bool lockRotation = false;

  /// lock rotation rotation
  double lockRotationValue = 0;

  /// true when all components are loaded
  bool isAllComponentsLoaded = false;

  GamePlayerObject({
    required this.gameObject,
    required this.plockGame,
  });

  @override
  Future<void> onLoad() async {
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

    bodyDef = forge2d.BodyDef()
      ..position = forge2d.Vector2(gameObject.position.x, gameObject.position.y)
      // rotation from degree to radian
      ..angle = gameObject.rotation * 3.141592653589793 / 180.0
      ..type = forge2d.BodyType.static
      ..userData = this;

    fixtureDefs = [
      forge2d.FixtureDef(
        forge2d.PolygonShape()
          ..setAsBoxXY((width / 2), (height / 2)),
        density: 1.0,
        friction: 0.3,
        isSensor: true,
      ),
    ];

    EventManager.registerEvents(js, plockGame, gameObject.id);
    js.onMessage("getNeedAbort", (args) => needAbort);
    handlePromises();

    // Update the components
    gameObject.isPhysicsDirty = true;
    plockGame.isDirty = true;
    updateDisplay();
    updateEvents();

    // init events
    js.evaluate("let collider = \"\";");
    js.evaluate("let colliderName = \"\";");
    js.evaluate("let params = [];");

    // Execute the start events
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_START') {
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }

    await super.onLoad();
  }

  /// Update the display components.
  Future<void> updateDisplay() async {
    this.priority = gameObject.layer;

    if (!gameObject.enabled) {
      for (var component in this.children) {
        if (component is ComponentFlame) {
          if (component is forge2d.BodyComponent) {
            world.remove(component);
          } else {
            remove(component);
          }
        }
      }
      return;
    }

    List<String> alreadyDisplayed = [];

    // Update the components that are already instanced
    for (int i = 0; i < this.children.length; i++) {
      var component = this.children.elementAt(i);
      if (component is ComponentFlame) {
        ComponentFlame componentFlame = component as ComponentFlame;
        ComponentType componentType = componentFlame.getComponentType();
        this.bodyDef = (await componentType.updateDisplay(component, this)).bodyDef;
        alreadyDisplayed.add(componentFlame.getComponentType().uuid);
      }
    }

    // update the components that are already instanced in world
    for (var component in this.world.children) {
      if (component is ComponentFlame) {
        ComponentFlame componentFlame = component as ComponentFlame;
        ComponentType componentType = componentFlame.getComponentType();
        this.bodyDef = (await componentType.updateDisplay(component, this)).bodyDef;
        alreadyDisplayed.add(componentFlame.getComponentType().uuid);
      }
    }

    // Add the new components
    for (var component in gameObject.components) {
        if (!alreadyDisplayed.contains(component.uuid)) {
          Component? comp = component.getGameDisplayComponent(
            plockGame.medias,
            onTapUp,
            onDragStart,
            onDragUpdate,
            onDragEnd,
            onDragCancel);
          if (comp != null) {
            if (comp is forge2d.BodyComponent) {
              comp.bodyDef!.position = forge2d.Vector2(gameObject.position.x, gameObject.position.y);
              world.add(comp);
            } else {
              add(comp);
            }
            ComponentFlame componentFlame = comp as ComponentFlame;
            ComponentType componentType = componentFlame.getComponentType();
            try {
              final updatedThis = await componentType.updateDisplay(comp, this);
              this.bodyDef = updatedThis.bodyDef;
            } catch (e) {
              plockGame.isDirty = true;
            }
          }
        }
    }

    if (gameObject.force != null) {
      body.applyForce(forge2d.Vector2(gameObject.force!.x, gameObject.force!.y));
      gameObject.force = null;
    }

    if (gameObject.velocity != null) {
      body.linearVelocity = forge2d.Vector2(gameObject.velocity!.x, gameObject.velocity!.y);
      gameObject.velocity = null;
    }

  }

  void updatePhysic() {

      try {
        body.angle;
      } catch (e) {
        // body is not created yet
        return;
      }

      if (gameObject.isPhysicsDirty && body.isAwake) {
        gameObject.isPhysicsDirty = false;
        forge2d.Vector2 oldPos = this.body.position;
        double oldAngle = this.body.angle;
        if (gameObject.isPositionDirty) {
          oldPos = forge2d.Vector2(gameObject.position.x, gameObject.position.y);
          gameObject.isPositionDirty = false;
        }
        world.destroyBody(body);
        bodyDef!.position = oldPos;
        bodyDef!.angle = oldAngle;
        this.body = world.createBody(bodyDef!);
        for (var fixtureDef in fixtureDefs!) {
          body.createFixture(fixtureDef);
        }
      } else {
        if (gameObject.isPositionDirty) {
          gameObject.isPositionDirty = false;
          body.setTransform(
              forge2d.Vector2(gameObject.position.x, gameObject.position.y),
              body.angle);
          for (var contact in body.contacts) {
            forge2d.Vector2 pos = contact.bodyB.position;
            contact.bodyB.setTransform(pos, contact.bodyB.angle);
            contact.bodyB.setAwake(true);
          }
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
    bodyDef?.position = forge2d.Vector2(gameObject.position.x, gameObject.position.y);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var comp in displayComponents) {
      if (comp is ComponentFlame) {
        final cf = comp as ComponentFlame;
        if (!cf.isFullyLoaded()) {
          print("Not fully loaded");
          return;
        }
      }
    }

    isAllComponentsLoaded = true;

    if (lockX) {
      body.linearVelocity = forge2d.Vector2(0, body.linearVelocity.y);
      body.position.x = lockXPosition;
    }

    if (lockY) {
      body.linearVelocity = forge2d.Vector2(body.linearVelocity.x, 0);
      body.position.y = lockYPosition;
    }

    if (lockRotation) {
      body.angularVelocity = 0;
      body.setTransform(body.position, lockRotationValue);
    }

    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_UPDATE') {
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }

      for (var contact in beginContacts) {
        for (var component in eventComponents) {
          if (component.fields['trigger']!.value == 'ON_BEGIN_COLLISION') {
            GamePlayerObject contactObjectA = contact.bodyB
                .userData as GamePlayerObject;
            GamePlayerObject contactObjectB = contact.bodyA
                .userData as GamePlayerObject;
            GameObject contactGameObject = contactObjectA.gameObject.id ==
                gameObject.id ? contactObjectB.gameObject : contactObjectA
                .gameObject;
            executeEvent(
                component.fields['event']!.value[0], contactGameObject.id,
                contactGameObject.name);
          }
        }
      }
      beginContacts = [];

      for (var contact in endContacts) {
        for (var component in eventComponents) {
          if (component.fields['trigger']!.value == 'ON_END_COLLISION') {
            GamePlayerObject contactObjectA = contact.bodyB
                .userData as GamePlayerObject;
            GamePlayerObject contactObjectB = contact.bodyA
                .userData as GamePlayerObject;
            GameObject contactGameObject = contactObjectA.gameObject.id ==
                gameObject.id ? contactObjectB.gameObject : contactObjectA
                .gameObject;
            executeEvent(
                component.fields['event']!.value[0], contactGameObject.id,
                contactGameObject.name);
          }
        }
      }
    }
  }

  bool onTapUp(TapUpEvent info) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_TAP') {
          plockGame.lastTouchPosition =
              Vector2(info.localPosition.x, info.localPosition.y);
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
    return true;
  }

  void onDragStart(DragStartEvent event) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_START_DRAG') {
          double x = event.canvasPosition.x;
          double y = event.canvasPosition.y;
          plockGame.lastTouchPosition = Vector2(x, y);
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
  }

  void onDragUpdate(DragUpdateEvent event) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_DRAG') {
          double x = event.canvasStartPosition.x + event.canvasDelta.x;
          double y = event.canvasStartPosition.y + event.canvasDelta.y;
          plockGame.lastTouchPosition = Vector2(x, y);
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
  }

  void onDragEnd(DragEndEvent event) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_END_DRAG') {
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
  }

  void onDragCancel(DragCancelEvent event) {
  }

  /// Execute an event.
  Future<void> executeEvent(String event, int collider, String colliderName, {List<String> params = const []}) async {
    if (!gameObject.enabled) {
      return;
    }

    // add break in while loops
    event = event.replaceAll("while (", "while (!sendMessage(\"getNeedAbort\", JSON.stringify([])) && ");

    // add collider to the event an wrap it in a function
    var eventModified =
    "collider = $collider\n"
    "colliderName = \"$colliderName\"\n"
    "params = ";
    if (params.isNotEmpty) {
      eventModified += "[";
      for (var param in params) {
        eventModified += "\"$param\",";
      }
      eventModified = eventModified.substring(0, eventModified.length - 1);
      eventModified += "];\n";
    } else {
      eventModified += "[];\n";
    }
    eventModified += "async function event() {\n"
    "  $event\n"
    "}\n"
    "event();\n";

    js.evaluateAsync(eventModified).then(
          (JsEvalResult jsResult) {
        if (jsResult.isError) {
          print("Error in event: ${jsResult.stringResult}");
        }
      },
    ).catchError((error) {
      print("Error in event: $error");
    });
  }

  void stopEvents() {
    needAbort = true;
  }

  Future<void> handlePromises() async {
    while (true) {
      js.executePendingJob();
      if (needAbort) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  @override
  void beginContact(Object other, forge2d.Contact contact) {
    super.beginContact(other, contact);

    if (other is GamePlayerObject) {
      beginContacts.add(contact);
    }
  }

  @override
  void endContact(Object other, forge2d.Contact contact) {
    super.endContact(other, contact);

    if (other is GamePlayerObject) {
      endContacts.add(contact);
    }
  }
}

