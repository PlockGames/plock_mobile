import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';

void main() {
  group('Tilemap', () {
    test('constructor initializes map with correct dimensions', () {
      final tilemap = Tilemap(10, 10);
      expect(tilemap.map.length, equals(Tilemap.NB_LAYERS));
      expect(tilemap.map[0].length, equals(10));
      expect(tilemap.map[0][0].length, equals(10));
    });

    test('changeSize correctly adjusts map dimensions', () {
      final tilemap = Tilemap(10, 10);
      final newSize = tilemap.changeSize(12, 12, ExpandDirection.right, ExpandDirection.bottom);

      expect(newSize.x, equals(12.0));
      expect(newSize.y, equals(12.0));
      expect(tilemap.width, equals(12));
      expect(tilemap.height, equals(12));
    });

    test('changeSize respects maximum dimensions', () {
      final tilemap = Tilemap(Tilemap.MAX_WIDTH, Tilemap.MAX_HEIGHT);
      final newSize = tilemap.changeSize(
          Tilemap.MAX_WIDTH * 2,
          Tilemap.MAX_HEIGHT * 2,
          ExpandDirection.right,
          ExpandDirection.bottom
      );

      expect(newSize.x, equals(Tilemap.MAX_WIDTH.toDouble()));
      expect(newSize.y, equals(Tilemap.MAX_HEIGHT.toDouble()));
    });

    test('setTile/getTile work correctly', () {
      final tilemap = Tilemap(10, 10);
      tilemap.setTile(0, 5, 5, 42);
      expect(tilemap.getTile(0, 5, 5), equals(42));
    });

    test('getTile returns 0 for out-of-bounds', () {
      final tilemap = Tilemap(10, 10);
      expect(tilemap.getTile(0, 15, 15), equals(0));
    });

    test('changeSize throws for invalid horizontal direction', () {
      final tilemap = Tilemap(10, 10);
      expect(
            () => tilemap.changeSize(12, 12, ExpandDirection.top, ExpandDirection.bottom),
        throwsA(isA<Exception>()),
      );
    });

    test('changeSize throws for invalid vertical direction', () {
      final tilemap = Tilemap(10, 10);
      expect(
            () => tilemap.changeSize(12, 12, ExpandDirection.right, ExpandDirection.left),
        throwsA(isA<Exception>()),
      );
    });
  });
}