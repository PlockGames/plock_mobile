import 'package:plock_mobile/models/utils/Vector2.dart';
import '../../data/ComponentList.dart';
import 'component_type.dart';
import 'game_object_type.dart';

/// A game object that can be added to a game.
class GameObject {
  /// The id of the object.
  late int id;

  /// The name of the object.
  late String name;

  /// The components of the object.
  List<ComponentType> components = List<ComponentType>.empty(growable: true);

  /// The position of the object.
  Vector2 position = Vector2(0, 0);

  /// The rotation of the object.
  double rotation = 0;

  /// The type of the object.
  GameObjectType type = GameObjectType.object;

  /// the id of the asset, if the object is an asset
  int? assetId;

  /// The parent of the object, if any.
  GameObject? parent;

  /// The layer of the object.
  int layer = 0;

  /// If the object is locked, it can't be moved in the editor.
  bool locked = false;

  /// If the object is Visible in the editor.
  bool visible = true;

  /// If the object is enabled
  bool enabled = true;

  /// is position dirty
  bool isPositionDirty = false;

  /// is physics dirty
  bool isPhysicsDirty = false;

  /// set force
  Vector2? force;

  /// set velocity
  Vector2? velocity;

  GameObject({required this.id, required this.name});

  /// Return a copy of the object
  GameObject instance() {
    GameObject instance = GameObject(id: id, name: name);
    instance.position = Vector2(position.x, position.y);
    instance.rotation = rotation;
    instance.type = type;
    instance.assetId = assetId;
    instance.parent = parent;
    instance.layer = layer;
    instance.locked = locked;
    instance.visible = visible;
    instance.enabled = enabled;
    for (var component in components) {
      instance.components.add(component.instance());
    }
    return instance;
  }

  /// Convert the object to a JSON string.
  String toJson() {
    String json = "{";
    json += "\"id\": $id,";
    json += "\"name\": \"$name\",";
    json += "\"components\": [";
    components.forEach((element) {
      json += element.toJson();
      if (components.indexOf(element) != components.length - 1) {
        json += ",";
      }
    });
    json += "],";
    json += "\"position\": ${position.toJson()}";
    json += "}";

    return json;
  }

  /// Create a GameObject from a JSON object.
  static GameObject fromJson(Map<String, dynamic> json) {
    GameObject gameObject = GameObject(id: json['id'], name: json['name']);
    gameObject.position = Vector2.fromJson(json['position']);
    for (var component in json['components']) {
      var componentModel = ComponentList.getByName(component["type"]);
      if (componentModel == null) {
        continue;
      }
      var comp = componentModel.instance();
      comp.fields.forEach((key, value) {
        value.updateFromJson(component[key]);
      });
      gameObject.components.add(comp);
    }
    return gameObject;
  }
}
