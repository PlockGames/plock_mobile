import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/models/component_flame/component_flame_circle.dart';
import 'package:plock_mobile/models/component_types/component_circle.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

/// A flame object that represents a game object in te game engine.
class GamePlayerObject extends PositionComponent {

  /// The game object linked to this Flame object.
  late GameObject gameObject;

  /// The game data.
  late Game game;

  /// List of all the components that can be displayed.
  List<Component> displayComponents = [];

  /// List of all the events components.
  List<ComponentType> eventComponents = [];

  /// Lua state, used to execute events.
  LuaState lua = LuaState.newState();

  GamePlayerObject({
    required this.gameObject,
    required this.game,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Set the object data
    size = Vector2(50, 50);
    position = Vector2(gameObject.position.x, gameObject.position.y);

    await lua.openLibs();
    EventManager.registerEvents(lua, game, gameObject.id);

    // Update the components
    updateDisplay();
    updateEvents();

    // Execute the start events
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_START') {
        executeEvent(component.fields['event']!.value);
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
        componentType.updateDisplay(component);
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
          }
        }
    }

    // Remove the components that are not in the game object
    // TODO

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
    position = Vector2(gameObject.position.x, gameObject.position.y);
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

        executeEvent(component.fields['event']!.value);
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
