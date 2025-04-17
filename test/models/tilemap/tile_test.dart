import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';

void main() {
  group('Tile Tests', () {
    test('Le constructeur par défaut initialise les valeurs correctement', () {
      final tile = Tile();
      expect(tile.media, equals(''));
      expect(tile.collision, equals([]));  // Vérifie si la liste est vide
    });

    test('Vérifie l\'initialisation de Tile avec des valeurs spécifiques', () {
      final tile = Tile()
        ..media = 'Tile Media'
        ..collision = [true, false, true];

      expect(tile.media, equals('Tile Media'));
      expect(tile.collision, equals([true, false, true]));
    });

    test('Vérifie que la liste collision est modifiable', () {
      final tile = Tile();
      tile.collision.add(true);
      expect(tile.collision, contains(true));
    });
  });
}
