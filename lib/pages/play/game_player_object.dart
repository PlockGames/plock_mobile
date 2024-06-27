import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

class GamePlayerObject extends PositionComponent with TapCallbacks {

  late GameObject gameObject;
  late Game game;

  List<Component> displayComponents = [];
  List<ComponentType> eventComponents = [];
  List<double> timers = [];
  LuaState lua = LuaState.newState();


  String name = 'Object';

  GamePlayerObject({
    required this.gameObject,
    required this.game,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await lua.openLibs();
    EventManager.registerEvents(lua, game);


    size = Vector2(50, 50);
    position = Vector2(gameObject.position.x, gameObject.position.y);
    updateDisplay();
    updateEvents();

    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_START') {
        executeEvent(component.fields['event']!.value);
      }
    }
  }

  void updateDisplay() {
    for (var component in displayComponents) {
      remove(component);
    }
    displayComponents = [];

    for (var component in gameObject.components) {
      Component? displayComponent = component.getGameDisplayComponent();
      if (displayComponent != null) {
        displayComponents.add(displayComponent);
        add(displayComponent);
      }
    }
  }

  void updateEvents() {
    eventComponents = [];
    for (var component in gameObject.components) {
      if (component.type == 'ComponentEvent') {
        eventComponents.add(component);
      }
    }
  }

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

    for (var timer in timers) {
      timer -= dt;
      if (timer <= 0) {
      }
    }

    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_UPDATE') {
        executeEvent(component.fields['event']!.value);
      }
    }
  }

  @override
  Future<bool> onTapUp(TapUpEvent info) async {
    print("on tap");
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_TAP') {
        executeEvent(component.fields['event']!.value);
      }
    }
    return true;
  }

  String gameToLua() {
    String result = "game = {";
    for (var object in game.objects) {
      result += object.name + " = {";

      for (var component in object.components) {
        if (component.type == 'ComponentEvent') {
          continue;
        }
        result += component.type + " = {";
        for (var field in component.fields.keys) {
          result += "$field = ${component.fields[field]!.value},";
        }
        result += "},";
      }
      result += "};";
    }
    result += "};";
    return result;
  }

  executeEvent(String event) {
    lua.loadString(event);
    lua.call(0, 0);
  }

}
