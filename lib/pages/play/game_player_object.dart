import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

/// A flame object that represents a game object in te game engine.
class GamePlayerObject extends BodyComponent {

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

  GamePlayerObject({
    required this.gameObject,
    required this.plockGame,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Set the object data
    renderBody = false;

    bodyDef = BodyDef()
      ..position = Vector2(gameObject.position.x, gameObject.position.y)
      ..type = BodyType.static;

    fixtureDefs = [
      FixtureDef(
        PolygonShape()
          ..setAsBoxXY(20, 20),
        density: 1.0,
        friction: 0.3,
      ),
    ];



    await lua.openLibs();
    EventManager.registerEvents(lua, plockGame, gameObject.id);

    // Update the components
    updateDisplay();
    updateEvents();

    // Execute the start events
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_START') {
        executeEvent(component.fields['event']!.value[0]);
      }
    }
  }

  /// Update the display components.
  void updateDisplay() {
    List<ComponentType> alreadyDisplayed = [];

    // Update the components that are already instancied
    for (var component in this.children) {
      print(component);
      if (component is ComponentFlame) {
        ComponentFlame componentFlame = component as ComponentFlame;
        if (componentFlame.getComponentType() == null) {
          continue;
        }
        ComponentType componentType = componentFlame.getComponentType()!;
        print(componentType.name);
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

    world.destroyBody(body);
    print(bodyDef!.type);
    this.body = world.createBody(bodyDef!);
    for (var fixtureDef in fixtureDefs!) {
      body.createFixture(fixtureDef);
    }
    print(this.body.bodyType);

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

        executeEvent(component.fields['event']!.value[0]);
      }
    }
  }

  bool onTapUp(TapUpEvent info) {
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_TAP') {

        executeEvent(component.fields['event']!.value);
      }
    }
    return true;
  }

  void onDragStart(DragStartEvent event) {
  }

  void onDragUpdate(DragUpdateEvent event) {
  }

  void onDragEnd(DragEndEvent event) {
  }

  void onDragCancel(DragCancelEvent event) {
  }

  /// Execute an event.
  Future<void> executeEvent(String event) async {
    // fix until modules works as expected
    event = event.replaceAll("math.", "");
    event = event.replaceAll("table.", "");
    event = event.replaceAll("string.", "");
    event = event.replaceAll("#", "len ");

    lua.loadString(event);
    await lua.call(0, 0);
  }

  void stopEvents() {
    try {
      lua.error();
    } catch (e) {
      print("Game interrupted");
    }
  }

}
