import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/scene.dart';

void main() {
  group('Scene', () {
    test('initialization with default values', () {
      final scene = Scene();
      expect(scene.name, 'new scene');
      expect(scene.objects, isEmpty);
      expect(scene.uiObjects, isEmpty);
    });

    test('initialization with a name', () {
      final scene = Scene(name: 'Test Scene');
      expect(scene.name, 'Test Scene');
      expect(scene.objects, isEmpty);
      expect(scene.uiObjects, isEmpty);
    });

    test('instance() creates a deep copy', () {
      final scene = Scene(name: 'Original Scene');
      scene.objects.add(GameObject(id: 1, name: 'Object 1'));
      scene.uiObjects.add(GameObject(id: 2, name: 'UI Object 1'));

      final copy = scene.instance();
      expect(copy.name, 'Original Scene');
      expect(copy.objects.length, 1);
      expect(copy.uiObjects.length, 1);
      expect(copy.objects[0].id, 1);
      expect(copy.uiObjects[0].id, 2);

      // Verify that the objects are deep copies
      expect(copy.objects[0], isNot(same(scene.objects[0])));
      expect(copy.uiObjects[0], isNot(same(scene.uiObjects[0])));
    });

    test('toJson() returns valid JSON string', () {
      final scene = Scene(name: 'JSON Scene');
      scene.objects.add(GameObject(id: 3, name: 'Object 3'));
      scene.uiObjects.add(GameObject(id: 4, name: 'UI Object 4'));

      final jsonString = scene.toJson();
      final expectedJson = """
    {
      "name": "JSON Scene",
      "objects": [
        {"id": 3,"name": "Object 3","layer":0,"enabled":true,"type":"object","locked":false,"visible":true,"keep":false,"components":[],"position": {"x":0.0,"y":0.0}}
      ],
      "uiObjects": [
        {"id": 4,"name": "UI Object 4","layer":0,"enabled":true,"type":"object","locked":false,"visible":true,"keep":false,"components":[],"position": {"x":0.0,"y":0.0}}
      ]
    }
    """;
      expect(jsonString.replaceAll(RegExp(r'\s'), ''), expectedJson.replaceAll(RegExp(r'\s'), ''));
    });
  });
}