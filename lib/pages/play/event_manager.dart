import 'package:lua_dardo_async/debug.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/models/component_types/component_circle.dart';

import '../../models/component_types/component_rect.dart';
import '../../models/component_types/component_text.dart';
import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

typedef EventAsync = Future<int> Function(LuaState lua);
typedef Event = int Function(LuaState lua);

class EventManager {

  static void registerEvents(LuaState lua, Game game) {
      lua.registerAsync("wait", _wait(game));
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
  }

  static EventAsync _wait(Game game) {
    return (lua) async {
      int? time = await lua.checkInteger(1);
      lua.printStack();
      if (time != null) {
        await Future.delayed(Duration(milliseconds: time));
        return 0;
      }
      return 0;
    };
  }

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