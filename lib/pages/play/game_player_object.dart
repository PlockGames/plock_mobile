import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:lua_dardo/debug.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:lua_dardo/lua.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

class GamePlayerObject extends PositionComponent with TapCallbacks {

  late GameObject gameObject;
  late Game game;

  List<Component> displayComponents = [];
  List<ComponentType> eventComponents = [];


  String name = 'Object';

  GamePlayerObject({
    required this.gameObject,
    required this.game,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
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

    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_UPDATE') {
        executeEvent(component.fields['event']!.value);
      }
    }
  }

  @override
  bool onTapUp(TapUpEvent info) {
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

  void executeEvent(String event) {
    LuaState lua = LuaState.newState();
    lua.openLibs();
    print('''${gameToLua()}
    result = {};
    i = 1;
    $event''');
    lua.loadString('''${gameToLua()}
    result = {};
    i = 1;
    $event''');
    lua.call(0, 0);
    lua.getGlobal("result");
    if (lua.isTable(-1)) {
      final size = lua.len2(-1);
      for (int i = 1; i <= size!; i++) {
        lua.pushInteger(i);
        lua.getTable(-2);
        if (lua.isString(-1)) {
          var result = lua.toStr(-1);
          if (result != null) {
            print(result);
            EventManager.callEvent(result, game);
          }
        }
        lua.pop(1);
      }
    }
  }
}
