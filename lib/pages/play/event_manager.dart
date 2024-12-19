import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_js/flutter_js.dart';
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
import '../../models/utils/Vector2.dart' as PVector2;
import 'game_player_object.dart';

typedef EventAsync = Future<int> Function(LuaState lua);
typedef Event = int Function(LuaState lua);

/// Register all the events that can be executed by the lua vm.
class EventManager {

  /// Register all the game events available.
  ///
  /// [lua] The lua vm to register the events to.
  /// [game] The game data to execute the events on.
  static void registerEvents(JavascriptRuntime js, Game game, int thisObjectId) {
      // Colour
      js.onMessage("rgbToColor", (args) => _rgbToColor(game, thisObjectId, args));
      // System
      js.onMessage("wait", (args) async => await _wait(game, thisObjectId, args));
      js.onMessage("getScreenValue", (args) => _getScreenSize(game, thisObjectId, args));
      js.onMessage("deltaTime", (args) => _deltaTime(game, thisObjectId, args));
      js.onMessage("getTouch", (args) => _getTouch(game, thisObjectId, args));
      // Objects
      js.onMessage("thisObject", (args) => _thisObject(game, thisObjectId, args));
      js.onMessage("lastObject", (args) => _lastObject(game, thisObjectId, args));
      js.onMessage("objectByName", (args) => _getObjectByName(game, thisObjectId, args));
      js.onMessage("getComponentValue", (args) => _getComponentValue(game, thisObjectId, args));
      js.onMessage("setComponentValue", (args) => _setComponentValue(game, thisObjectId, args));
      js.onMessage("addComponent", (args) => _addComponent(game, thisObjectId, args));
      js.onMessage("destroyObject", (args) => _destroyObject(game, thisObjectId, args));
      js.onMessage("getObjectValue", (args) => _getObjectValue(game, thisObjectId, args));
      js.onMessage("setObjectValue", (args) => _setObjectValue(game, thisObjectId, args));
      js.onMessage("spawnObject", (args) => _spawnObject(game, thisObjectId, args));
      js.onMessage("addForce", (args) => _setAddForce(game, thisObjectId, args));
  }

  /// Return delta time
  static double _deltaTime(Game game, int thisObjectId, dynamic args) {
    return game.deltaTime;
  }

  /// Return the touch position
  static double _getTouch(Game game, int thisObjectId, dynamic args) {
      String value = args[0];
      Vector2? touchPosition = game.gamePlayer?.screenToWorld(game.lastTouchPosition);
      if (touchPosition == null) {
        return 0;
      }

      if (value == "X") {
        return touchPosition.x;
      } else if (value == "Y") {
        return touchPosition.y;
      }
      return 0;
  }

  /// Wait for a certain amount of time.
  static Future<void> _wait(Game game, int thisObjectId, dynamic args) async {
    int time = args[0];
    await Future.delayed(Duration(milliseconds: time));
  }

  static String? _rgbToColor(Game game, int thisObjectId, dynamic args) {
      // args
      int red = args[0];
      int green = args[1];
      int blue = args[2];

      int r = red.clamp(0, 255);
      int g = green.clamp(0, 255);
      int b = blue.clamp(0, 255);
      String color = "#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}";
      return color;
  }

  /// Return the screen size.
  static double _getScreenSize(Game game, int thisObjectId, dynamic args) {
      String value = args[0];

      if (value == "WIDTH") {
        return game.screenSize.x;
      } else if (value == "HEIGHT") {
        return game.screenSize.y;
      }
      return 0;
  }

  /// return this object id
  static int _thisObject(Game game, int thisObjectId, dynamic args) {
    return thisObjectId;
  }

  /// return the last spawned object
  static int _lastObject(Game game, int thisObjectId, dynamic args) {
    return game.objects.last.id;
  }

  /// get object by name
  static int _getObjectByName(Game game, int thisObjectId, dynamic args) {
      String name = args[0];
      try {
        GameObject? object = game.objects.firstWhere((element) =>
        element.name == name);
        return object.id;
      } catch (e) {
        print("Error(getObjectByName): $e");
        return 0;
      }
  }

  /// Return the property of a component of an object.
  static dynamic _getComponentValue(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String component = args[1];
    String property = args[2];

    try {
      GameObject object = game.objects.firstWhere((element) => element.id == objectId);
      var componentType = object.components.firstWhere((element) => element.type == component);
      for (int i = 0; i < componentType.fields.length; i++) {
        if (componentType.fields.keys.elementAt(i) == property.toLowerCase()) {

          var value = componentType.fields.values.elementAt(i).value;
          if (value is double) {
            return value;
          } else if (value is int) {
            return value;
          } else if (value is String) {
            return value;
          } else if (value is Color) {
            return "#${value.value.toRadixString(16).padLeft(8, '0')}";
          } else {
            return null;
          }
        }
      }
    } catch (e) {
      print("Error(getComponentValue): $e");
      return null;
    }
  }

  /// Set the property of a component of an object.
  static void _setComponentValue(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String component = args[1];
    String property = args[2];
    String value = args[3].toString();

    try {
      GameObject object = game.objects.firstWhere((element) => element.id == objectId);
      var componentType = object.components.firstWhere((element) => element.type == component);
      for (int i = 0; i < componentType.fields.length; i++) {
        if (componentType.fields.keys.elementAt(i) == property.toLowerCase()) {

          if (componentType.fields.values.elementAt(i) is ComponentFieldNumber) {
            componentType.fields.values.elementAt(i).value = double.parse(value);
            game.isDirty = true;
          } else if (componentType.fields.values.elementAt(i) is ComponentFieldText) {
            componentType.fields.values.elementAt(i).value = value;
            game.isDirty = true;
          } else if (componentType.fields.values.elementAt(i) is ComponentFieldColour) {
            value = "ff${value!.substring(4)}";
            Color color = Color(int.parse(value, radix: 16));
            componentType.fields.values.elementAt(i).value = color;
            game.isDirty = true;
          } else if (componentType.fields.values.elementAt(i) is ComponentFieldDropDown) {
            componentType.fields.values.elementAt(i).value = value!;
            game.isDirty = true;
          } else if (componentType.fields.values.elementAt(i) is ComponentFieldBlockly) {
            componentType.fields.values.elementAt(i).value[0] = value!;
            game.isDirty = true;
          }
        }
      }
    } catch (e) {
      print("Error(setComponentValue): $e");
    }
  }

  /// Add a component to an object.
  static void _addComponent(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String component = args[1];
    String name = args[2];

    try {
      GameObject object = game.objects.firstWhere((element) => element.id == objectId);
      ComponentType componentTypeModel = ComponentList.getByName(component);
      ComponentType componentType = componentTypeModel.instance();

      if (componentType is ComponentEvent) {
        componentType.fields['name']!.value = name!;
      }
      object.components.add(componentType);
    } catch (e) {
      print("Error(addComponent): $e");
    }
  }

  /// Destroy an object.
  static void _destroyObject(Game game, int thisObjectId, dynamic args) {
    int? objectId = args[0];

    try {
      GameObject object = game.objects.firstWhere((element) => element.id == objectId);
      game.objects.remove(object);
    } catch (e) {
      print("Error(destroyObject): $e");
    }
  }

  /// Get the value of an object.
  static double _getObjectValue(Game game, int thisObjectId, dynamic args) {
      int objectId = args[0];
      String property = args[1];

      try {
        GameObject object = game.objects.firstWhere((element) => element.id == objectId);
        if (property.toLowerCase() == "x") {
          return object.position.x;
        } else if (property.toLowerCase() == "y") {
          return object.position.y;
        } else {
          return 0;
        }
      } catch (e) {
        print("Error(getObjectValue): $e");
        return 0;
      }
  }

  /// Set the value of an object.
  static void _setObjectValue(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String property = args[1];
    double value = args[2].toDouble();

    try {
      GameObject object = game.objects.firstWhere((element) => element.id == objectId);
      if (property.toLowerCase() == "x") {
        object.position.x = value;
        object.isPositionDirty = true;
        game.isDirty = true;
      } else if (property.toLowerCase() == "y") {
        object.position.y = value;
        object.isPositionDirty = true;
        game.isDirty = true;
      }
    } catch (e) {
      print("Error(setObjectValue): $e");
    }
  }

  static void _setAddForce(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String property = args[1];
    double value = double.parse(args[2]);
    try {
      GameObject object = game.objects.firstWhere((element) =>
      element.id == objectId);

      if (property.toLowerCase() == "x") {
        object.force = PVector2.Vector2(value.toDouble(), 0);
        game.isDirty = true;
      } else if (property.toLowerCase() == "y") {
        object.force = PVector2.Vector2(0, value.toDouble());
        game.isDirty = true;
      }
    } catch (e) {
      print("Error(setObjectValue): $e");
    }
  }

  /// Spawn an object.
  static void _spawnObject(Game game, int thisObjectId, dynamic args) {
    String name = args[0];

    try {
      game.spawnObject(name);
    } catch (e) {
      print("Error(spawnObject): $e");
    }
  }

  void test() {
  }

}