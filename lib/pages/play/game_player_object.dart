import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

/// A flame object that represents a game object in te game engine.
class GamePlayerObject extends PositionComponent with TapCallbacks {

  /// The game object linked to this Flame object.
  late GameObject gameObject;

  /// The game data.
  late Game game;

  /// List of all the components that can be displayed.
  List<Component> displayComponents = [];

  /// List of all the events components.
  List<ComponentType> eventComponents = [];

  /// The lua vm to execute events.
  LuaState lua = LuaState.newState();

  GamePlayerObject({
    required this.gameObject,
    required this.game,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    print("loading !");
    // Load the lua state to execute events
    await lua.openLibs();
    EventManager.registerEvents(lua, game, gameObject.id);

    // Set the object data
    size = Vector2(50, 50);
    position = Vector2(gameObject.position.x, gameObject.position.y);

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
    // Empty the display component list
    for (var component in displayComponents) {
      remove(component);
    }
    displayComponents = [];

    // Fill the display component list with updated components
    for (var component in gameObject.components) {
      Component? displayComponent = component.getGameDisplayComponent();
      if (displayComponent != null) {
        displayComponents.add(displayComponent);
        add(displayComponent);
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

  @override
  Future<bool> onTapUp(TapUpEvent info) async {
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_TAP') {
        print("ON_TAP");
        executeEvent(component.fields['event']!.value);
      }
    }
    return true;
  }

  /// Execute an event.
  Future<void> executeEvent(String event) async {
    lua.loadString(event);
    await lua.call(0, 0);
  }

}
