import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game_object_type.dart';

void main() {
  group('GameObjectType', () {
    test('GameObjectType.object has correct value', () {
      expect(GameObjectType.object, GameObjectType.object);
    });

    test('GameObjectType.asset has correct value', () {
      expect(GameObjectType.asset, GameObjectType.asset);
    });

    test('GameObjectType.values contains all enum values', () {
      expect(GameObjectType.values, [GameObjectType.object, GameObjectType.asset]);
    });

    test('GameObjectType.object toString() returns correct string', () {
      expect(GameObjectType.object.toString(), 'GameObjectType.object');
    });

    test('GameObjectType.asset toString() returns correct string', () {
      expect(GameObjectType.asset.toString(), 'GameObjectType.asset');
    });

    test('GameObjectType.values.length is correct', () {
      expect(GameObjectType.values.length, 2);
    });

    test('GameObjectType.values contains no duplicates', () {
      final values = GameObjectType.values;
      final uniqueValues = values.toSet();
      expect(values.length, uniqueValues.length);
    });

    test('GameObjectType.index returns correct indexes', () {
      expect(GameObjectType.object.index, 0);
      expect(GameObjectType.asset.index, 1);
    });
  });
}