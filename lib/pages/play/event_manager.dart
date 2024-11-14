import 'dart:math';
import 'dart:ui';

import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';

import '../../models/component_fields/component_field_color.dart';
import '../../models/component_fields/component_field_number.dart';
import '../../models/games/component_type.dart';
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
      // Colour
      lua.registerAsync("rgbToColor", _rgbToColor(game, thisObjectId));
      // System
      lua.registerAsync("wait", _wait(game, thisObjectId));
      lua.register("getScreenValue", _getScreenSize(game, thisObjectId));
      lua.register("deltaTime", _deltaTime(game, thisObjectId));
      // Objects
      lua.register("thisObject", _thisObject(game, thisObjectId));
      lua.register("lastObject", _lastObject(game, thisObjectId));
      lua.register("objectByName", _getObjectByName(game, thisObjectId));
      lua.registerAsync("getComponentValue", _getComponentValue(game, thisObjectId));
      lua.registerAsync("setComponentValue", _setComponentValue(game, thisObjectId));
      lua.registerAsync("addComponent", _addComponent(game, thisObjectId));
      lua.registerAsync("destroyObject", _destroyObject(game, thisObjectId));
      lua.registerAsync("getObjectValue", _getObjectValue(game, thisObjectId));
      lua.registerAsync("setObjectValue", _setObjectValue(game, thisObjectId));
      lua.registerAsync("spawnObject", _spawnObject(game, thisObjectId));
  }

  /// Return delta time
  static Event _deltaTime(Game game, int thisObjectId) {
    return (lua) {
      lua.pushNumber(game.deltaTime);
      return 1;
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
        lua.pushString(color);
        return 1;
      }
      return 0;
    };
  }

  /// Return the screen size.
  static Event _getScreenSize(Game game, int thisObjectId) {
    return (lua) {
      String? value = lua.checkString(1);
      lua.pop(1);

      if (value != null) {
        if (value == "WIDTH") {
          lua.pushNumber(game.screenSize.x);
          return 1;
        } else if (value == "HEIGHT") {
          lua.pushNumber(game.screenSize.y);
          return 1;
        }
      }
      return 1;
    };
  }

  /// return this object id
  static Event _thisObject(Game game, int thisObjectId) {
    return (lua) {
      lua.pushInteger(thisObjectId);
      return 1;
    };
  }

  /// return the last spawned object
  static Event _lastObject(Game game, int thisObjectId) {
    return (lua) {
      lua.pushInteger(game.objects.last.id);
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
          print("Error(getObjectByName): $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Return the property of a component of an object.
  static Future<int> Function(LuaState lua) _getComponentValue(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? component = lua.checkString(2);
      String? property = lua.checkString(3);
      lua.pop(3);

      if (objectId != null && component != null && property != null) {
        try {
          GameObject object = game.objects.firstWhere((element) => element.id == objectId);
          var componentType = object.components.firstWhere((element) => element.type == component);
          for (int i = 0; i < componentType.fields.length; i++) {
            if (componentType.fields.keys.elementAt(i) == property.toLowerCase()) {

              var value = componentType.fields.values.elementAt(i).value;
              if (value is double) {
                lua.pushNumber(value);
              } else if (value is int) {
                lua.pushInteger(value);
              } else if (value is String) {
                lua.pushString(value);
              } else if (value is Color) {
                lua.pushString("#${value.value.toRadixString(16).padLeft(8, '0')}");
              } else {
                lua.pushNil();
              }
              return 1;
            }
          }
        } catch (e) {
          print("Error(getComponentValue): $e");
          return 0;
        }
      }

      return 0;
    };
  }

  /// Set the property of a component of an object.
  static Future<int> Function(LuaState lua) _setComponentValue(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? component = lua.checkString(2);
      String? property = lua.checkString(3);
      String? value = lua.checkString(4);
      lua.pop(4);

      if (objectId != null && component != null && property != null) {
        try {
          GameObject object = game.objects.firstWhere((element) => element.id == objectId);
          var componentType = object.components.firstWhere((element) => element.type == component);
          for (int i = 0; i < componentType.fields.length; i++) {
            if (componentType.fields.keys.elementAt(i) == property.toLowerCase()) {

              if (componentType.fields.values.elementAt(i) is ComponentFieldNumber) {
                componentType.fields.values.elementAt(i).value = double.parse(value!);
              } else if (componentType.fields.values.elementAt(i) is ComponentFieldText) {
                componentType.fields.values.elementAt(i).value = value!;
              } else if (componentType.fields.values.elementAt(i) is ComponentFieldColour) {
                componentType.fields.values.elementAt(i).value = Color(int.parse(value!.substring(1), radix: 16));
              } else if (componentType.fields.values.elementAt(i) is ComponentFieldDropDown) {
                componentType.fields.values.elementAt(i).value = value!;
              } else if (componentType.fields.values.elementAt(i) is ComponentFieldBlockly) {
                componentType.fields.values.elementAt(i).value[0] = value!;
              } else {
                return 0;
              }
              return 0;
            }
          }
        } catch (e) {
          print("Error(setComponentValue): $e");
          return 0;
        }
      }

      return 0;
    };
  }

  /// Add a component to an object.
  static Future<int> Function(LuaState lua) _addComponent(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? component = lua.checkString(2);
      String? name = lua.checkString(3);
      lua.pop(3);

      if (objectId != null && component != null) {
        try {
          GameObject object = game.objects.firstWhere((element) => element.id == objectId);
          ComponentType componentTypeModel = ComponentList.getByName(component);
          ComponentType componentType = componentTypeModel.instance();

          if (componentType is ComponentEvent) {
            componentType.fields['name']!.value = name!;
          }
          object.components.add(componentType);
          return 0;
        } catch (e) {
          print("Error(addComponent): $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Destroy an object.
  static Future<int> Function(LuaState lua) _destroyObject(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      lua.pop(1);

      if (objectId != null) {
        try {
          GameObject object = game.objects.firstWhere((element) => element.id == objectId);
          game.objects.remove(object);
          return 0;
        } catch (e) {
          print("Error(destroyObject): $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Get the value of an object.
  static Future<int> Function(LuaState lua) _getObjectValue(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? property = lua.checkString(2);
      lua.pop(2);

      if (objectId != null && property != null) {
        try {
          GameObject object = game.objects.firstWhere((element) => element.id == objectId);
          if (property.toLowerCase() == "x") {
            lua.pushNumber(object.position.x);
          } else if (property.toLowerCase() == "y") {
            lua.pushNumber(object.position.y);
          } else {
            return 0;
          }
          return 1;
        } catch (e) {
          print("Error(getObjectValue): $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Set the value of an object.
  static Future<int> Function(LuaState lua) _setObjectValue(Game game, int thisObjectId) {
    return (lua) async {
      int? objectId = await lua.checkInteger(1);
      String? property = lua.checkString(2);
      double? value = await lua.checkNumber(3);
      lua.pop(3);

      if (objectId != null && property != null && value != null) {
        try {
          GameObject object = game.objects.firstWhere((element) => element.id == objectId);
          if (property.toLowerCase() == "x") {
            object.position.x = value;
          } else if (property.toLowerCase() == "y") {
            object.position.y = value;
          }
          return 0;
        } catch (e) {
          print("Error(setObjectValue): $e");
          return 0;
        }
      }
      return 0;
    };
  }

  /// Spawn an object.
  static Future<int> Function(LuaState lua) _spawnObject(Game game, int thisObjectId) {
    return (lua) async {
      String? name = lua.checkString(1);
      lua.pop(1);

      if (name != null) {
        try {
          game.spawnObject(name);
          return 0;
        } catch (e) {
          print("Error(spawnObject): $e");
          return 0;
        }
      }
      return 0;
    };
  }

}