import 'dart:convert';

import 'package:plock_mobile/models/utils/Vector2.dart';
import 'component_type.dart';

class GameObject {
  late String name;
  List<ComponentType> components = List<ComponentType>.empty(growable: true);
  Vector2 position = Vector2(20, 20);

  GameObject({required this.name});

  String toJson() {
    String json = "{";
    json += "\"name\": \"$name\",";
    json += "\"components\": [";
    components.forEach((element) {
      json += element.toJson();
    });
    json += "],";
    json += "\"position\": ${position.toJson()}";
    json += "}";

    return json;
  }
}
