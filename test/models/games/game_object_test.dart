import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';
import 'package:plock_mobile/models/components/component_type.dart';
import 'package:plock_mobile/models/components/transform_component.dart';
import 'package:plock_mobile/models/components/physics_component.dart';
import 'package:plock_mobile/models/games/game_object_type.dart';

void main() {
  group('GameObject', () {
    late GameObject gameObject;

    setUp(() {
      gameObject = GameObject(id: 1, name: 'Test Object');
    });

    test('instance() creates a deep copy of the GameObject', () {
      gameObject.position = Vector2(10, 20);
      gameObject.rotation = 45;
      gameObject.type = GameObjectType.asset;
      gameObject.assetId = 2;
      gameObject.layer = 1;
      gameObject.locked = true;
      gameObject.visible = false;
      gameObject.enabled = false;
      gameObject.components.add(TransformComponent());

      final gameObjectCopy = gameObject.instance();

      expect(gameObjectCopy.id, gameObject.id);
      expect(gameObjectCopy.name, gameObject.name);
      expect(gameObjectCopy.position, gameObject.position);
      expect(gameObjectCopy.rotation, gameObject.rotation);
      expect(gameObjectCopy.type, gameObject.type);
      expect(gameObjectCopy.assetId, gameObject.assetId);
      expect(gameObjectCopy.layer, gameObject.layer);
      expect(gameObjectCopy.locked, gameObject.locked);
      expect(gameObjectCopy.visible, gameObject.visible);
      expect(gameObjectCopy.enabled, gameObject.enabled);
      expect(gameObjectCopy.components.length, gameObject.components.length);
      expect(gameObjectCopy.components[0].runtimeType, gameObject.components[0].runtimeType);
      expect(gameObjectCopy.components[0], isNot(same(gameObject.components[0])));
    });

    test('toJson() converts the GameObject to a JSON string', () {
      gameObject.position = Vector2(5, 10);
      gameObject.components.add(TransformComponent());
      gameObject.components.add(PhysicsComponent());

      final jsonString = gameObject.toJson();
      final expectedJson = '{"id": 1,"name": "Test Object","components": [{"type": "TransformComponent","position": {"x": 0.0,"y": 0.0},"rotation": 0.0},{"type": "PhysicsComponent","mass": 1.0,"restitution": 0.0,"friction": 0.0}],"position": {"x": 5.0,"y": 10.0}}';

      expect(jsonString, expectedJson);
    });

    test('fromJson() creates a GameObject from a JSON object', () {
      final json = {
        'id': 2,
        'name': 'New Object',
        'position': {'x': 15.0, 'y': 25.0},
        'components': [
          {'type': 'TransformComponent', 'position': {'x': 1.0, 'y': 2.0}, 'rotation': 90.0},
          {'type': 'PhysicsComponent', 'mass': 2.0, 'restitution': 0.5, 'friction': 0.8},
        ],
      };

      final gameObjectFromJson = GameObject.fromJson(json);

      expect(gameObjectFromJson.id, 2);
      expect(gameObjectFromJson.name, 'New Object');
      expect(gameObjectFromJson.position, Vector2(15, 25));
      expect(gameObjectFromJson.components.length, 2);
      expect(gameObjectFromJson.components[0].runtimeType, TransformComponent);
      expect((gameObjectFromJson.components[0] as TransformComponent).position, Vector2(1,2));
      expect((gameObjectFromJson.components[0] as TransformComponent).rotation, 90.0);

      expect(gameObjectFromJson.components[1].runtimeType, PhysicsComponent);
      expect((gameObjectFromJson.components[1] as PhysicsComponent).mass, 2.0);
      expect((gameObjectFromJson.components[1] as PhysicsComponent).restitution, 0.5);
      expect((gameObjectFromJson.components[1] as PhysicsComponent).friction, 0.8);
    });

    test('fromJson() handles unknown component types gracefully', () {
      final json = {
        'id': 3,
        'name': 'Object with Unknown Component',
        'position': {'x': 0.0, 'y': 0.0},
        'components': [
          {'type': 'UnknownComponent', 'someField': 'someValue'},
        ],
      };

      final gameObjectFromJson = GameObject.fromJson(json);

      expect(gameObjectFromJson.components.length, 0); // No component added
    });
  });
}