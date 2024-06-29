import 'dart:math';
import 'dart:ui';

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
  static void registerEvents(LuaState lua, Game game, int thisObjectId) {
      // System
      lua.registerAsync("wait", _wait(game, thisObjectId));
      lua.register("getScreenWidth", _getScreenWidth(game, thisObjectId));
      lua.register("getScreenHeight", _getScreenHeight(game, thisObjectId));
      // Rect component
      lua.registerAsync("changeRectWidth", _changeRectWidth(game, thisObjectId));
      lua.registerAsync("changeRectHeight", _changeRectHeight(game, thisObjectId));
      lua.registerAsync("changeRectColor", _changeRectColor(game, thisObjectId));
      lua.registerAsync("getRectWidth", _getRectWidth(game, thisObjectId));
      lua.registerAsync("getRectHeight", _getRectHeight(game, thisObjectId));
      lua.registerAsync("getRectColour", _getRectColour(game, thisObjectId));
      // Text component
      lua.registerAsync("changeTextText", _changeTextText(game, thisObjectId));
      lua.registerAsync("changeTextColor", _changeTextColor(game, thisObjectId));
      lua.registerAsync("getTextText", _getTextText(game, thisObjectId));
      lua.registerAsync("getTextColour", _getTextColour(game, thisObjectId));
      // Circle component
      lua.registerAsync("changeCircleRadius", _changeCircleRadius(game, thisObjectId));
      lua.registerAsync("changeCircleColour", _changeCircleColour(game, thisObjectId));
      lua.registerAsync("getCircleRadius", _getCircleRadius(game, thisObjectId));
      lua.registerAsync("getCircleColour", _getCircleColour(game, thisObjectId));
      // Object
      lua.registerAsync("changeObjectPosX", _changeObjectPosX(game, thisObjectId));
      lua.registerAsync("changeObjectPosY", _changeObjectPosY(game, thisObjectId));
      lua.registerAsync("getObjectPosX", _getObjectPosX(game, thisObjectId));
      lua.registerAsync("getObjectPosY", _getObjectPosY(game, thisObjectId));
      lua.registerAsync("objectMove", _objectMove(game, thisObjectId));
      lua.register("thisObject", _thisObject(game, thisObjectId));
      lua.register("getObjectByName", _getObjectByName(game, thisObjectId));

  }

  /// Get circle colour
  static EventAsync _getCircleColour(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
          ComponentCircle circle = object.components.firstWhere((element) =>
          element.type == "ComponentCircle") as ComponentCircle;
          Color color = circle.fields["color"]!.value;
          String hex = "#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}";
          print(hex);
          lua.pushString(hex);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get rect colour
  static EventAsync _getRectColour(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
          ComponentRect rect = object.components.firstWhere((element) =>
          element.type == "ComponentRect") as ComponentRect;
          Color color = rect.fields["color"]!.value;
          String hex = "#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}";
          lua.pushString(hex);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get text colour
  static EventAsync _getTextColour(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
          ComponentText text = object.components.firstWhere((element) =>
          element.type == "ComponentText") as ComponentText;
          Color color = text.fields["color"]!.value;
          String hex = "#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}";
          lua.pushString(hex);
          return 1;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Change circle compoonent color
  static EventAsync _changeCircleColour(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? newColor = lua.checkString(2);
      lua.pop(2);
      if (objectId != null && newColor != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
          ComponentCircle circle = object.components.firstWhere((element) =>
          element.type == "ComponentCircle") as ComponentCircle;
          newColor = newColor.replaceAll("#", "");
          if (newColor.length == 6) {
            newColor = "FF$newColor";
          }
          int b = newColor.length == 8 ? int.parse(newColor.substring(6, 8), radix: 16) : 255;
          circle.fields["color"]!.value = Color(int.parse(newColor, radix: 16));
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Change rect component color
  static EventAsync _changeRectColor(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? newColor = lua.checkString(2);
      lua.pop(2);
      if (objectId != null && newColor != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
          ComponentRect rect = object.components.firstWhere((element) =>
          element.type == "ComponentRect") as ComponentRect;
          newColor = newColor.replaceAll("#", "");
          if (newColor.length == 6) {
            newColor = "FF$newColor";
          }
          int b = newColor.length == 8 ? int.parse(newColor.substring(6, 8), radix: 16) : 255;
          rect.fields["color"]!.value = Color(int.parse(newColor, radix: 16));
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Change text component color
  static EventAsync _changeTextColor(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? newColor = lua.checkString(2);
      lua.pop(2);
      if (objectId != null && newColor != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
          ComponentText text = object.components.firstWhere((element) =>
          element.type == "ComponentText") as ComponentText;
          newColor = newColor.replaceAll("#", "");
          if (newColor.length == 6) {
            newColor = "FF$newColor";
          }
          int b = newColor.length == 8 ? int.parse(newColor.substring(6, 8), radix: 16) : 255;
          text.fields["color"]!.value = Color(int.parse(newColor, radix: 16));
          game.isDirty = true;
        } catch (e) {
          print("Error: $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Wait for a certain amount of time.
  static EventAsync _wait(Game game, int thisObjectId) {
    return (lua) async {
      int? time = await lua.checkInteger(1);
      if (time != null) {
        await Future.delayed(Duration(milliseconds: time));
        return 0;
      }
      return 0;
    };
  }

  static EventAsync _rgbToColor(Game game, int thisObjectId) {
    return (lua) async {
      int? red = await lua.checkInteger(1);
      int? green = await lua.checkInteger(2);
      int? blue = await lua.checkInteger(3);
      lua.pop(3);
      if (red != null && green != null && blue != null) {
        int r = red.clamp(0, 255);
        int g = green.clamp(0, 255);
        int b = blue.clamp(0, 255);
        String color = "#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}";
        print(color);
        lua.pushString(color);
        return 1;
      }
      return 0;
    };
  }

  /// Return the screen width.
  static Event _getScreenWidth(Game game, int thisObjectId) {
    return (lua) {
      lua.pushNumber(game.screenSize.x);
      return 1;
    };
  }

  /// Return the screen height.
  static Event _getScreenHeight(Game game, int thisObjectId) {
    return (lua) {
      lua.pushNumber(game.screenSize.y);
      return 1;
    };
  }

  /// Change the width of a rect component.
  static EventAsync _changeRectWidth(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      int? newWidth = await lua.checkInteger(2);
      lua.pop(2);
      if (objectId != null && newWidth != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _changeRectHeight(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      int? newHeight = await lua.checkInteger(2);
      lua.pop(2);
      if (objectId != null && newHeight != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _changeTextText(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? newText = lua.checkString(2);
      lua.pop(2);
      if (objectId != null && newText != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _changeObjectPosX(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      double? newPosX = lua.checkNumber(2);
      lua.pop(2);
      if (objectId != null && newPosX != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _changeObjectPosY(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      double? newPosY = lua.checkNumber(2);
      lua.pop(2);
      if (objectId != null && newPosY != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _objectMove(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      double? targetX = lua.checkNumber(2);
      double? targetY = lua.checkNumber(3);
      double? speed = lua.checkNumber(4);
      lua.pop(4);
      if (objectId != null && targetX != null && targetY != null && speed != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _changeCircleRadius(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      int? newRadius = await lua.checkInteger(2);
      lua.pop(2);
      if (objectId != null && newRadius != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _getRectWidth(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _getRectHeight(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _getTextText(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _getCircleRadius(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _getObjectPosX(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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
  static EventAsync _getObjectPosY(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);
      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) =>
          element.id == objectId);
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

  /// return this object id
  static Event _thisObject(Game game, int thisObjectId) {
    return (lua) {
      lua.pushInteger(thisObjectId);
      return 1;
    };
  }

  /// get object by name
  static Event _getObjectByName(Game game, int thisObjectId) {
    return (lua) {
      String? name = lua.checkString(1);
      if (name != null) {
        try {
        GameObject? object = game.objects.firstWhere((element) =>
        element.name == name);
        lua.pushInteger(object.id);
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