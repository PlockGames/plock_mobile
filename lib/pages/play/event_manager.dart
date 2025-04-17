import 'dart:ffi';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_js_plus/flutter_js.dart';
import 'package:flutter_js_plus/quickjs/ffi.dart';
import 'package:lua_dardo_async/lua.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/pages/play/game_player_object.dart';

import '../../models/component_fields/component_field_color.dart';
import '../../models/component_fields/component_field_number.dart';
import '../../models/games/component_type.dart';
import '../../models/games/game.dart';
import '../../models/games/game_object.dart';
import '../../models/utils/Vector2.dart' as PVector2;
import 'game_player_ui_object.dart';

typedef EventAsync = Future<int> Function(LuaState lua);
typedef Event = int Function(LuaState lua);

/// Register all the events that can be executed by the lua vm.
class EventManager {

  /// Register all the game events available.
  ///
  /// [lua] The lua vm to register the events to.
  /// [game] The game data to execute the events on.
  /// [thisObjectId] The id of the object that the events are executed on.
  static void registerEvents(JavascriptRuntime js, Game game, int thisObjectId) {
      // Colour
      js.onMessage("rgbToColor", (args) => _rgbToColor(game, thisObjectId, args));
      // System
      js.onMessage("wait", (args) async => await _wait(game, thisObjectId, args));
      js.onMessage("getScreenValue", (args) => _getScreenSize(game, thisObjectId, args));
      js.onMessage("getCameraValue", (args) => _getCameraValue(game, thisObjectId, args));
      js.onMessage("setCameraValue", (args) => _setCameraValue(game, thisObjectId, args));
      js.onMessage("deltaTime", (args) => _deltaTime(game, thisObjectId, args));
      js.onMessage("getTouch", (args) => _getTouch(game, thisObjectId, args));
      js.onMessage("changeScene", (args) => _changeScene(game, thisObjectId, args));
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
      js.onMessage("spawnAsset", (args) => _spawnAsset(game, thisObjectId, args));
      js.onMessage("addForce", (args) => _setAddForce(game, thisObjectId, args));
      js.onMessage("setForce", (args) => _setSetForce(game, thisObjectId, args));
      js.onMessage("getVariableValue", (args) => _getVariableValue(game, thisObjectId, args));
      js.onMessage("setVariableValue", (args) => _setVariableValue(game, thisObjectId, args));
      js.onMessage("getListValue", (args) => _getListValue(game, thisObjectId, args));
      js.onMessage("setListValue", (args) => _setListValue(game, thisObjectId, args));
      js.onMessage("changeSprite", (args) => _changeSprite(game, thisObjectId, args));
      js.onMessage("objectEnable", (arg) => _objectEnable(game, thisObjectId, arg));
      js.onMessage("objectIsEnabled", (arg) => _objectIsEnabled(game, thisObjectId, arg));
      js.onMessage("triggerEvent", (args) => _triggerEvent(game, thisObjectId, args));

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

  /// Change the scene.
  static void _changeScene(Game game, int thisObjectId, dynamic args) {
    String sceneName = args[0];
    int sceneIndex = game.scenes.indexWhere((element) => element.name == sceneName);
    if (sceneIndex != -1) {
      game.currentSceneIndex = sceneIndex;

      for (int i = 0; i < game.gamePlayer!.components.length; i++) {
        var object = game.gamePlayer!.components[i];
        if (object is GamePlayerObject && object.gameObject.keep == false) {
          game.gamePlayer!.world.remove(object);
          game.gamePlayer!.components.removeAt(i);
          i--;
        }
      }

      for (var object in game.gamePlayer!.world.children) {
        if (object is ComponentFlame) {
          game.gamePlayer!.world.remove(object);
        }
      }

      for (var object in game.gamePlayer!.uiComponents) {
        if (object is GamePlayerUiObject) {
          game.gamePlayer!.camera.viewport.remove(object);
        }
      }
      game.gamePlayer!.uiComponents.clear();

      game.gamePlayer!.components.addAll(game.scenes[sceneIndex].objects.map((e) => GamePlayerObject(gameObject: e, plockGame: game)));
      game.gamePlayer!.uiComponents.addAll(game.scenes[sceneIndex].uiObjects.map((e) => GamePlayerUiObject(gameObject: e, plockGame: game)));

      game.gamePlayer!.components.forEach((element) {
        if (element.parent == null) {
          game.gamePlayer!.world.add(element);
        }
      });

      game.gamePlayer!.uiComponents.forEach((element) {
        game.gamePlayer!.camera.viewport.add(element);
      });
    }

    game.isDirty = true;
    game.gamePlayer?.camera.viewfinder.position = Vector2(0, 0);
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

  /// Return the camera value.
  static double _getCameraValue(Game game, int thisObjectId, dynamic args) {
    String value = args[0];

    if (value == "X") {
      return game.gamePlayer?.camera.viewfinder.position.x ?? 0;
    } else if (value == "Y") {
      return game.gamePlayer?.camera.viewfinder.position.y ?? 0;
    }
    return 0;
  }

  /// Return the camera value.
  static void _setCameraValue(Game game, int thisObjectId, dynamic args) {
    String value = args[0];
    double newValue = args[1].toDouble();
    //print("Set camera value: $value, $newValue");

    if (value == "X") {
      game.gamePlayer?.camera.viewfinder.position =
          Vector2(newValue, game.gamePlayer?.camera.viewfinder.position.y ?? 0);
    } else if (value == "Y") {
      game.gamePlayer?.camera.viewfinder.position =
          Vector2(game.gamePlayer?.camera.viewfinder.position.x ?? 0, newValue);
    }
  }

  /// return this object id
  static int _thisObject(Game game, int thisObjectId, dynamic args) {
    return thisObjectId;
  }

  /// return the last spawned object
  static int _lastObject(Game game, int thisObjectId, dynamic args) {
    return game.scenes[game.currentSceneIndex].objects.last.id;
  }

  /// get object by name
  static int _getObjectByName(Game game, int thisObjectId, dynamic args) {
      String name = args[0];
      try {
        GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) =>
        element.name == name);
        object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) =>
          element.name == name);
        if (object == null) {
          final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.name == name) as GamePlayerObject?;
          if (objectComponent != null) {
            object = objectComponent.gameObject;
          }
        }
        if (object == null) {
          print("Error(getObjectByName): Object not found");
          return -1;
        }
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
      GameObject object = game.scenes[game.currentSceneIndex].objects.firstWhere((element) => element.id == objectId);
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
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) => element.id == objectId);
      if (object == null) {
        object = game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) => element.id == objectId);
        component = "ComponentUi" + component.split("Component").last;
      }

      if (object == null) {
        final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.id == objectId) as GamePlayerObject?;
        if (objectComponent != null) {
          object = objectComponent.gameObject;
        }
      }

        if (object == null) {
          print("Error(setComponentValue): Object not found");
          return;
        }

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
              value = "ff${value.substring(4)}";
              Color color = Color(int.parse(value, radix: 16));
              componentType.fields.values.elementAt(i).value = color;
              game.isDirty = true;
            } else if (componentType.fields.values.elementAt(i) is ComponentFieldDropDown) {
              componentType.fields.values.elementAt(i).value = value;
              game.isDirty = true;
            } else if (componentType.fields.values.elementAt(i) is ComponentFieldBlockly) {
              componentType.fields.values.elementAt(i).value[0] = value;
              game.isDirty = true;
            }
          }
        }
    } catch (e) {
      print("Error(setComponentValue): $e");
    }
  }

  /// Set the property of a component of an object.
  static void _setVariableValue(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String name = args[1];
    String value = args[2].toString();

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) => element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) => element.id == objectId);
      if (object == null) {
        final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.id == objectId) as GamePlayerObject?;
        if (objectComponent != null) {
          object = objectComponent.gameObject;
        }
      }
      if (object == null) {
        print("Error(setVariableValue): Object not found");
        return;
      }
      var componentType = object.components.firstWhere((element) => element.type == "ComponentVariable" && element.fields["name"]!.value == name);
      componentType.fields["value"]!.value = value;
    } catch (e) {
      print("Error(setVariableValue): $e");
    }
  }

  /// Add a component to an object.
  static void _addComponent(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String component = args[1];
    String name = args[2];

    try {
      GameObject object = game.scenes[game.currentSceneIndex].objects.firstWhere((element) => element.id == objectId);
      ComponentType componentTypeModel = ComponentList.getByName(component);
      ComponentType componentType = componentTypeModel.instance();

      if (componentType is ComponentEvent) {
        componentType.fields['name']!.value = name;
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
      GameObject object = game.scenes[game.currentSceneIndex].objects.firstWhere((element) => element.id == objectId);
      game.scenes[game.currentSceneIndex].objects.remove(object);
      game.isDirty = true;
    } catch (e) {
      print("Error(destroyObject): $e");
    }
  }

  /// Get the value of an object.
  static double _getObjectValue(Game game, int thisObjectId, dynamic args) {
      int objectId = args[0];
      String property = args[1];

      try {
        List<Component> components = game.gamePlayer!.components;
        GamePlayerObject? gameObject;
        for (Component component in components) {
          if (component is GamePlayerObject) {
            if (component.gameObject.id == objectId) {
              gameObject = component;
              break;
            }
          }
        }
        if (property.toLowerCase() == "x") {
          return gameObject?.position.x ?? 0;
        } else if (property.toLowerCase() == "y") {
          return gameObject?.position.y ?? 0;
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
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) => element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) => element.id == objectId);
      if (object == null) {
        final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.id == objectId) as GamePlayerObject?;
        if (objectComponent != null) {
          object = objectComponent.gameObject;
        }
      }
      if (object == null) {
        print("Error(setObjectValue): Object not found");
        return;
      }
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
    double value = args[2].toDouble();
    //print("Add force: $objectId, $property, $value");
    try {
      GameObject object = game.scenes[game.currentSceneIndex].objects.firstWhere((element) => element.id == objectId);

      if (property.toLowerCase() == "x") {
        object.force = PVector2.Vector2(value.toDouble(), object.force?.y ?? 0);
        game.isDirty = true;
      } else if (property.toLowerCase() == "y") {
        object.force = PVector2.Vector2(object.force?.x ?? 0, value.toDouble());
        game.isDirty = true;
      }
    } catch (e) {
      print("Error(setAddForce): $e");
    }
  }

  static void _setSetForce(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String property = args[1];
    double value = args[2].toDouble();
    //print("Set force: $objectId, $property, $value");
    try {
      GameObject object = game.scenes[game.currentSceneIndex].objects.firstWhere((element) =>
      element.id == objectId);

      if (property.toLowerCase() == "x") {
        object.velocity = PVector2.Vector2(value.toDouble(), object.velocity?.y ?? 0);
        game.isDirty = true;
      } else if (property.toLowerCase() == "y") {
        object.velocity = PVector2.Vector2(object.velocity?.x ?? 0, value.toDouble());
        game.isDirty = true;
      }
    } catch (e) {
      print("Error(setSetForce): $e");
    }
  }

  static void _changeSprite(Game game, int thisObjectId, dynamic args) {
    int objectId = args[1];
    String name = args[0];
    bool isUi = false;

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) =>
      element.id == objectId);
      if (object == null) {
        object = game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) =>
        element.id == objectId);
        isUi = true;
      }
      if (object == null) {
        final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.id == objectId) as GamePlayerObject?;
        if (objectComponent != null) {
          object = objectComponent.gameObject;
        }
      }
      if (object == null) {
        print("Error(changeSprite): Object not found");
        return;
      }
      var componentType = object.components.firstWhere((element) => element.type == (isUi ? "ComponentUiSprite" : "ComponentSprite"));
      componentType.fields["current"]!.value = name;
      game.isDirty = true;
    } catch (e) {
      print("Error(changeSprite): $e");
    }
  }

  static void _objectEnable(Game game, int thisObjectId, dynamic args) {
    int objectId = args[1];
    bool enabled = args[0];

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) =>
      element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) =>
        element.id == objectId);
      if (object == null) {
        print("Error(objectEnable): Object not found");
        return;
      }
      object.enabled = enabled;
      game.isDirty = true;
    } catch (e) {
      print("Error(objectEnable): $e");
    }
  }

  static bool _objectIsEnabled(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) =>
      element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) =>
        element.id == objectId);
      if (object == null) {
        print("Error(objectIsEnabled): Object not found");
        return false;
      }
      return object.enabled;
    } catch (e) {
      print("Error(objectIsEnabled): $e");
      return false;
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

  /// Spawn an asset.
  static void _spawnAsset(Game game, int thisObjectId, dynamic args) {
    String name = args[0];
    String asset = args[1];

    try {
      game.spawnAsset(asset, name);
    } catch (e) {
      print("Error(spawnAsset): $e");
    }
  }

  /// Return the property of a component of an object.
  static dynamic _getVariableValue(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String name = args[1];

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) => element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) => element.id == objectId);
      if (object == null) {
        final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.id == objectId) as GamePlayerObject?;
        if (objectComponent != null) {
          object = objectComponent.gameObject;
        }
      }
      if (object == null) {
        print("Error(getVariableValue): Object not found");
        return null;
      }
      var componentType = object.components.firstWhere((element) => element.type == "ComponentVariable" && element.fields["name"]!.value == name);
      return componentType.fields["value"]!.value;
    } catch (e) {
      print("Error(getComponentValue): $e");
      return null;
    }
  }

  /// Return the list value of an object.
  static dynamic _getListValue(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String name = args[1];

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) => element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) => element.id == objectId);
      if (object == null) {
        final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.id == objectId) as GamePlayerObject?;
        if (objectComponent != null) {
          object = objectComponent.gameObject;
        }
      }
      if (object == null) {
        print("Error(getListValue): Object not found");
        return null;
      }
      var componentType = object.components.firstWhere((element) => element.type == "ComponentList" && element.fields["name"]!.value == name);
      return componentType.fields["values"]!.value;
    } catch (e) {
      print("Error(getListValue): $e");
      return null;
    }
  }

  /// Set the property of a component of an object.
  static void _setListValue(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String name = args[1];
    List<dynamic> value = args[2];
    List<String> list = value.map((e) => e.toString()).toList();

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) => element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) => element.id == objectId);
      if (object == null) {
        final objectComponent = game.gamePlayer?.components.firstWhereOrNull((element) => (element as GamePlayerObject).gameObject.id == objectId) as GamePlayerObject?;
        if (objectComponent != null) {
          object = objectComponent.gameObject;
        }
      }
      if (object == null) {
        print("Error(setListValue): Object not found");
        return;
      }
      var componentType = object.components.firstWhere((element) => element.type == "ComponentList" && element.fields["name"]!.value == name);
      componentType.fields["values"]!.value = list;
    } catch (e) {
      print("Error(setListValue): $e");
    }
  }

  /// Set the property of a component of an object.
  static void _triggerEvent(Game game, int thisObjectId, dynamic args) {
    int objectId = args[0];
    String name = args[1];
    List<dynamic> params = args[2];

    try {
      GameObject? object = game.scenes[game.currentSceneIndex].objects.firstWhereOrNull((element) => element.id == objectId);
      object ??= game.scenes[game.currentSceneIndex].uiObjects.firstWhereOrNull((element) => element.id == objectId);
      if (object == null) {
        print("Error(triggerEvent): Object not found");
        return;
      }
      var gamePlayerObject = game.gamePlayer?.components.firstWhere((element) => element is GamePlayerObject && element.gameObject.id == objectId) as GamePlayerObject?;
      ComponentEvent component = object.components.firstWhere((element) => element.type == "ComponentEvent" && element.fields["name"]!.value == name) as ComponentEvent;
      final paramsStr = params.map((e) => e.toString()).toList();
      gamePlayerObject?.executeEvent(component.fields['event']!.value[0], -1, "", params: paramsStr);
    } catch (e) {
      print("Error(triggerEvent): $e");
    }
  }

}