import 'game_object.dart';

class Scene {
  /// The name of the scene
  String name = "new scene";

  /// The objects in the game.
  List<GameObject> objects = List<GameObject>.empty(growable: true);

  /// the ui objects in the game
  List<GameObject> uiObjects = List<GameObject>.empty(growable: true);

  Scene({this.name = "new scene"});

  Scene instance() {
    Scene instance = Scene(name: name);

    for (var object in objects) {
      instance.objects.add(object.instance());
    }
    for (var object in uiObjects) {
      instance.uiObjects.add(object.instance());
    }

    return instance;
  }

  String toJson() {
    return """
    {
      "name": "$name",
      "objects": [
        ${objects.map((object) => object.toJson()).join(",")}
      ],
      "uiObjects": [
        ${uiObjects.map((object) => object.toJson()).join(",")}
      ]
    }
    """;
  }

  Scene.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    objects = (json["objects"] as List).map((object) => GameObject.fromJson(object)).toList();
    uiObjects = (json["uiObjects"] as List).map((object) => GameObject.fromJson(object)).toList();
  }


}