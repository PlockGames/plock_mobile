import 'dart:math';

import 'package:lua_dardo_async/debug.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/models/component_types/component_circle.dart';

import '../../models/component_types/component_rect.dart';
import '../../models/component_types/component_text.dart';
import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

typedef EventAsync = Future<int> Function(LuaState lua);
typedef Event = int Function(LuaState lua);

/// Register all the events that can be executed by the lua vm.
class EventManager {

  /// Register all the game events available.
  ///
  /// [lua] The lua vm to register the events to.
  /// [game] The game data to execute the events on.
  static void registerEvents(LuaState lua, Game game) {
      // System
      lua.registerAsync("wait", _wait(game));
      lua.register("getScreenWidth", _getScreenWidth(game));
      lua.register("getScreenHeight", _getScreenHeight(game));
      // Rect component
      lua.registerAsync("changeRectWidth", _changeRectWidth(game));
      lua.registerAsync("changeRectHeight", _changeRectHeight(game));
      lua.register("getRectWidth", _getRectWidth(game));
      lua.register("getRectHeight", _getRectHeight(game));
      // Text component
      lua.register("changeTextText", _changeTextText(game));
      lua.register("getTextText", _getTextText(game));
      // Circle component
      lua.registerAsync("changeCircleRadius", _changeCircleRadius(game));
      lua.register("getCircleRadius", _getCircleRadius(game));
      // Object
      lua.register("changeObjectPosX", _changeObjectPosX(game));
      lua.register("changeObjectPosY", _changeObjectPosY(game));
      lua.register("getObjectPosX", _getObjectPosX(game));
      lua.register("getObjectPosY", _getObjectPosY(game));
      lua.registerAsync("objectMove", _objectMove(game));
  }

  /// Wait for a certain amount of time.
  static EventAsync _wait(Game game) {
    return (lua) async {
      int? time = await lua.checkInteger(1);
      if (time != null) {
        await Future.delayed(Duration(milliseconds: time));
        return 0;
      }
      return 0;
    };
  }

  /// Return the screen width.
  static Event _getScreenWidth(Game game) {
    return (lua) {
      print(game.screenSize.x);
      lua.pushNumber(game.screenSize.x);
      return 1;
    };
  }

  /// Return the screen height.
  static Event _getScreenHeight(Game game) {
    return (lua) {
      print(game.screenSize.y);
      lua.pushNumber(game.screenSize.y);
      return 1;
    };
  }

  /// Change the width of a rect component.
  static EventAsync _changeRectWidth(Game game) {
    return (lua) async {
      String? objectName = lua.checkString(1);
      int? newWidth = await lua.checkInteger(2);
      lua.pop(2);
      if (objectName != null && newWidth != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentRect rect = object.components.firstWhere((element) =>
          element.type == "ComponentRect") as ComponentRect;
          rect.fields["width"]!.value = newWidth;
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Change the height of a rect component.
  static EventAsync _changeRectHeight(Game game) {
    return (lua) async {
      String? objectName = lua.checkString(1);
      int? newHeight = await lua.checkInteger(2);
      lua.pop(2);
      if (objectName != null && newHeight != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentRect rect = object.components.firstWhere((element) =>
          element.type == "ComponentRect") as ComponentRect;
          rect.fields["height"]!.value = newHeight;
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Change the text of a text component.
  static Event _changeTextText(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      String? newText = lua.checkString(2);
      lua.pop(2);
      if (objectName != null && newText != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentText text = object.components.firstWhere((element) =>
          element.type == "ComponentText") as ComponentText;
          text.fields["text"]!.value = newText;
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Change the x position of an object.
  static Event _changeObjectPosX(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      double? newPosX = lua.checkNumber(2);
      lua.pop(2);
      if (objectName != null && newPosX != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          object.position.x = newPosX;
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Change the y position of an object.
  static Event _changeObjectPosY(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      double? newPosY = lua.checkNumber(2);
      lua.pop(2);
      if (objectName != null && newPosY != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          object.position.y = newPosY;
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Move an object to a certain position.
  static EventAsync _objectMove(Game game) {
    return (lua) async {
      String? objectName = lua.checkString(1);
      double? targetX = lua.checkNumber(2);
      double? targetY = lua.checkNumber(3);
      double? speed = lua.checkNumber(4);
      lua.pop(4);
      if (objectName != null && targetX != null && targetY != null && speed != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          await _objectMoveAsync(game, object, targetX, targetY, speed);
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Move the object asynchronously. so the game can continue while the object is moving.
  ///
  /// [game] The game data to execute the events on.
  /// [gameObject] The object to move.
  /// [targetX] The target x position.
  /// [targetY] The target y position.
  /// [speed] The speed to move the object.
  static Future<void> _objectMoveAsync(Game game, GameObject gameObject, double targetX, double targetY, double speed) async {
    while (gameObject.position.x != targetX || gameObject.position.y != targetY) {
      double dx = targetX - gameObject.position.x;
      double dy = targetY - gameObject.position.y;
      double distance = dx * dx + dy * dy;
      if (distance < speed * speed) {
        gameObject.position.x = targetX;
        gameObject.position.y = targetY;
      } else {
        double angle = atan2(dy, dx);
        gameObject.position.x += cos(angle) * speed;
        gameObject.position.y += sin(angle) * speed;
      }
      game.isDirty = true;
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  /// Change the radius of a circle component.
  static EventAsync _changeCircleRadius(Game game) {
    return (lua) async {
      String? objectName = lua.checkString(1);
      int? newRadius = await lua.checkInteger(2);
      lua.pop(2);
      if (objectName != null && newRadius != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentCircle circle = object.components.firstWhere((element) =>
          element.type == "ComponentCircle") as ComponentCircle;
          circle.fields["radius"]!.value = newRadius;
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get the width of a rect component.
  static Event _getRectWidth(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      lua.pop(1);
      if (objectName != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentRect rect = object.components.firstWhere((element) =>
          element.type == "ComponentRect") as ComponentRect;
          lua.pushInteger(rect.fields["width"]!.value);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get the height of a rect component.
  static Event _getRectHeight(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      lua.pop(1);
      if (objectName != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentRect rect = object.components.firstWhere((element) =>
          element.type == "ComponentRect") as ComponentRect;
          lua.pushInteger(rect.fields["height"]!.value);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get the text of a text component.
  static Event _getTextText(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      lua.pop(1);
      if (objectName != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentText text = object.components.firstWhere((element) =>
          element.type == "ComponentText") as ComponentText;
          lua.pushString(text.fields["text"]!.value);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get the radius of a circle component.
  static Event _getCircleRadius(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      lua.pop(1);
      if (objectName != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          ComponentCircle circle = object.components.firstWhere((element) =>
          element.type == "ComponentCircle") as ComponentCircle;
          lua.pushInteger(circle.fields["radius"]!.value);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get the x position of an object.
  static Event _getObjectPosX(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      lua.pop(1);
      if (objectName != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          lua.pushNumber(object.position.x);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get the y position of an object.
  static Event _getObjectPosY(Game game) {
    return (lua) {
      String? objectName = lua.checkString(1);
      lua.pop(1);
      if (objectName != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.name == objectName);
          lua.pushNumber(object.position.y);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

}