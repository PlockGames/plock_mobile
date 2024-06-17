import 'dart:convert';

import 'game_object.dart';

class Game {
  final String name;
  List<GameObject> objects = List<GameObject>.empty(growable: true);

  Game({required this.name});

  String toJson() {
    String json = "{";
    json += "\"name\": \"$name\",";
    json += "\"objects\": [";
    objects.forEach((element) {
      json += element.toJson();
    });
    json += "]";
    json += "}";
    return json;
  }
}