import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_types/component_tilemap.dart';
void main() {
  group('ComponentTilemap', () {
    late ComponentTilemap componentTilemap;

    setUp(() {
      componentTilemap = ComponentTilemap();
    });

    test('constructor initializes basic properties', () {
      expect(componentTilemap, isNotNull);
      expect(componentTilemap.type, equals('ComponentTilemap'));
      expect(componentTilemap.name, equals('Tilemap'));
    });

    test('fields are properly initialized', () {
      expect(componentTilemap.fields.containsKey('size'), isTrue);
      expect(componentTilemap.fields.containsKey('map'), isTrue);
      expect(componentTilemap.fields.containsKey('tiles'), isTrue);
    });

    test('instance method creates a new object', () {
      final newInstance = componentTilemap.instance();

      expect(newInstance, isNotNull);
      expect(newInstance.type, equals('ComponentTilemap'));
      expect(newInstance, isNot(same(componentTilemap)));
    });
  });
}