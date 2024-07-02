import 'package:plock_mobile/models/utils/Vector2.dart';
import '../../data/ComponentList.dart';
import 'component_type.dart';

/// A game object that can be added to a game.
class GameObject {
  /// The id of the object.
  late int id;

  /// The name of the object.
  late String name;

  /// The components of the object.
  List<ComponentType> components = List<ComponentType>.empty(growable: true);

  /// The position of the object.
  Vector2 position = Vector2(50, 50);

  GameObject({required this.id, required this.name});

  /// Return a copy of the object
  GameObject instance() {
    GameObject instance = GameObject(id: id, name: name);
    instance.position = position;
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
      var comp = componentModel.instance();
      comp.fields.forEach((key, value) {
        value.updateFromJson(component[key]);
      });
      gameObject.components.add(comp);
    }
    return gameObject;
  }
}
