import 'dart:ui';

import 'package:flame/components.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:lua_dardo/lua.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

class GamePlayerObject extends PositionComponent {

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
    size = Vector2(0, 0);
    position = Vector2(gameObject.position.x, gameObject.position.y);
    updateDisplay();
    updateEvents();

    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_START') {
        LuaState lua = LuaState.newState();
        lua.openLibs();
        lua.loadString(component.fields['event']!.value);
        lua.call(0, 0);
        lua.getGlobal("result");
        if (lua.isString(-1)) {
          String? result = lua.toStr(-1);
          if (result != null) {
            EventManager.callEvent(result, game);
          }
        }
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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_UPDATE') {
        print("execute on update code :3");
      }
    }
  }
}
