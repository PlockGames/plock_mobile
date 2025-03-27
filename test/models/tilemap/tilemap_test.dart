import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';

void main() {
  group('Tilemap Tests', () {
    test('Le constructeur initialise correctement la carte avec les dimensions', () {
      final tilemap = Tilemap(10, 10);
      expect(tilemap.map.length, equals(Tilemap.NB_LAYERS)); // Should have 5 layers
      expect(tilemap.map[0].length, equals(10)); // Width = 10
      expect(tilemap.map[0][0].length, equals(10)); // Height = 10
    });

    test('La méthode changeSize ajuste correctement la taille de la carte', () {
      final tilemap = Tilemap(10, 10);

      // Change the size
      final Vector2 newSize = tilemap.changeSize(12, 12, ExpandDirection.right, ExpandDirection.bottom);

      // Verify that the new size is correct
      expect(newSize.x, equals(12.0));
      expect(newSize.y, equals(12.0));
      expect(tilemap.width, equals(12)); // Width = 12 after resizing
      expect(tilemap.height, equals(12)); // Height = 12 after resizing
    });

    test('La méthode changeSize ne dépasse pas les dimensions maximales', () {
      final tilemap = Tilemap(10000, 10000);

      // Try to expand beyond max width and height
      final Vector2 newSize = tilemap.changeSize(20000, 20000, ExpandDirection.right, ExpandDirection.bottom);

      // Verify that the size is clamped to max values
      expect(newSize.x, equals(Tilemap.MAX_WIDTH.toDouble()));
      expect(newSize.y, equals(Tilemap.MAX_HEIGHT.toDouble()));
      expect(tilemap.width, equals(Tilemap.MAX_WIDTH)); // Should be clamped to MAX_WIDTH
      expect(tilemap.height, equals(Tilemap.MAX_HEIGHT)); // Should be clamped to MAX_HEIGHT
    });

    test('La méthode setTile place correctement une tuile dans la carte', () {
      final tilemap = Tilemap(10, 10);

      // Set a tile at layer 0, position (5, 5)
      tilemap.setTile(0, 5, 5, 42);

      // Verify that the value is correctly placed
      expect(tilemap.getTile(0, 5, 5), equals(42));
    });

    test('La méthode getTile retourne 0 si la position est hors limites', () {
      final tilemap = Tilemap(10, 10);

      // Try to access a tile outside the bounds
      expect(tilemap.getTile(0, 15, 15), equals(0)); // Outside bounds
    });
    test('La méthode changeSize fonctionne avec des directions verticales et horizontales valides', () {
      final tilemap = Tilemap(10, 10);

      // Change size horizontally to the right and vertically to the bottom
      final Vector2 newSize = tilemap.changeSize(15, 15, ExpandDirection.right, ExpandDirection.bottom);

      expect(newSize.x, equals(15.0)); // New width
      expect(newSize.y, equals(15.0)); // New height

      // Check the map size after the expansion
      expect(tilemap.width, equals(15));
      expect(tilemap.height, equals(15));
    });

    test('La méthode changeSize lève une exception pour une direction horizontale invalide', () {
      final tilemap = Tilemap(10, 10);

      // Try to change size with invalid horizontal direction
      expect(() => tilemap.changeSize(12, 12, ExpandDirection.top, ExpandDirection.bottom),
          throwsA(isA<Exception>()));
    });

    test('La méthode changeSize lève une exception pour une direction verticale invalide', () {
      final tilemap = Tilemap(10, 10);

      // Try to change size with invalid vertical direction
      expect(() => tilemap.changeSize(12, 12, ExpandDirection.right, ExpandDirection.left),
          throwsA(isA<Exception>()));
    });
  });
}