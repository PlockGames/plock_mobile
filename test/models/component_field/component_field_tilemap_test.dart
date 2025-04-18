import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_page.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'dart:io';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/component_fields/component_field_texture.dart';
import 'package:plock_mobile/models/component_fields/component_field_tilemap.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';

// Classe factice pour Tile si elle n'est pas disponible
class _MockTile {
  final int id;
  final String name;

  _MockTile({required this.id, required this.name});
}

// Classe factice pour ComponentFieldTileset si elle n'est pas disponible
class _MockComponentFieldTileset extends ComponentField {
  final List<_MockTile> value;

  _MockComponentFieldTileset({required this.value, Function? onUpdate}) {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'MockTileset';

  @override
  Widget getField(String name, bool debug, List<Media> medias, Map<String, ComponentField> fields) {
    return Container();
  }

  @override
  ComponentField instance() {
    return _MockComponentFieldTileset(value: value, onUpdate: onUpdate);
  }

  @override
  String toJson() => '';

  @override
  void updateFromJson(dynamic jsonVal) {}
}

void main() {
  group('Tilemap', () {
    test('constructor initializes map with correct dimensions and -1 values', () {
      const width = 3;
      const height = 4;
      final tilemap = Tilemap(width, height);

      expect(tilemap.width, width);
      expect(tilemap.height, height);
      expect(tilemap.map.length, Tilemap.NB_LAYERS);
      for (final layer in tilemap.map) {
        expect(layer.length, width);
        for (final row in layer) {
          expect(row.length, height);
          expect(row.every((value) => value == -1), true);
        }
      }
    });

    test('changeSize expands map correctly from top-left', () {
      final tilemap = Tilemap(2, 2);
      tilemap.map[0][0][0] = 1;
      tilemap.map[0][1][1] = 2;

      final newSize = tilemap.changeSize(4, 3, ExpandDirection.left, ExpandDirection.top);

      expect(newSize.x, 4);
      expect(newSize.y, 3);
      expect(tilemap.width, 4);
      expect(tilemap.height, 3);
      expect(tilemap.map[0][0][0], 1);
      expect(tilemap.map[0][2][1], 2);
      expect(tilemap.map[0][3][0], -1);
      expect(tilemap.map[0][0][2], -1);
    });

    test('changeSize expands map correctly from bottom-right', () {
      final tilemap = Tilemap(2, 2);
      tilemap.map[0][0][0] = 1;
      tilemap.map[0][1][1] = 2;

      final newSize = tilemap.changeSize(4, 3, ExpandDirection.right, ExpandDirection.bottom);

      expect(newSize.x, 4);
      expect(newSize.y, 3);
      expect(tilemap.width, 4);
      expect(tilemap.height, 3);
      expect(tilemap.map[0][2][2], 1);
      expect(tilemap.map[0][3][1], 2);
      expect(tilemap.map[0][0][0], -1);
      expect(tilemap.map[0][3][0], -1);
    });

    test('changeSize expands map correctly from top-right', () {
      final tilemap = Tilemap(2, 2);
      tilemap.map[0][0][1] = 1;
      tilemap.map[0][1][0] = 2;

      final newSize = tilemap.changeSize(3, 3, ExpandDirection.right, ExpandDirection.top);

      expect(newSize.x, 3);
      expect(newSize.y, 3);
      expect(tilemap.width, 3);
      expect(tilemap.height, 3);
      expect(tilemap.map[0][1][2], 1);
      expect(tilemap.map[0][2][0], 2);
      expect(tilemap.map[0][0][0], -1);
      expect(tilemap.map[0][2][2], -1);
    });

    test('changeSize expands map correctly from bottom-left', () {
      final tilemap = Tilemap(2, 2);
      tilemap.map[0][0][1] = 1;
      tilemap.map[0][1][0] = 2;

      final newSize = tilemap.changeSize(3, 3, ExpandDirection.left, ExpandDirection.bottom);

      expect(newSize.x, 3);
      expect(newSize.y, 3);
      expect(tilemap.width, 3);
      expect(tilemap.height, 3);
      expect(tilemap.map[0][0][2], 1);
      expect(tilemap.map[0][1][1], 2);
      expect(tilemap.map[0][2][0], -1);
      expect(tilemap.map[0][0][0], -1);
    });

    test('changeSize does not change map if dimensions are the same', () {
      final tilemap = Tilemap(2, 2);
      final originalMap = List.generate(Tilemap.NB_LAYERS, (i) => List.generate(2, (x) => List.filled(2, -1)));
      for (int i = 0; i < Tilemap.NB_LAYERS; i++) {
        for (int x = 0; x < 2; x++) {
          for (int y = 0; y < 2; y++) {
            originalMap[i][x][y] = tilemap.map[i][x][y];
          }
        }
      }

      final newSize = tilemap.changeSize(2, 2, ExpandDirection.left, ExpandDirection.top);

      expect(newSize.x, 2);
      expect(newSize.y, 2);
      expect(tilemap.width, 2);
      expect(tilemap.height, 2);
      for (int i = 0; i < Tilemap.NB_LAYERS; i++) {
        for (int x = 0; x < 2; x++) {
          for (int y = 0; y < 2; y++) {
            expect(tilemap.map[i][x][y], originalMap[i][x][y]);
          }
        }
      }
    });

    test('changeSize clamps width and height to MAX values', () {
      final tilemap = Tilemap(1, 1);
      final newSize = tilemap.changeSize(Tilemap.MAX_WIDTH + 100, Tilemap.MAX_HEIGHT + 50, ExpandDirection.left, ExpandDirection.top);

      expect(newSize.x, Tilemap.MAX_WIDTH.toDouble());
      expect(newSize.y, Tilemap.MAX_HEIGHT.toDouble());
      expect(tilemap.width, Tilemap.MAX_WIDTH);
      expect(tilemap.height, Tilemap.MAX_HEIGHT);
    });

    test('changeSize throws exception for invalid horizontal direction', () {
      final tilemap = Tilemap(1, 1);
      expect(() => tilemap.changeSize(2, 2, ExpandDirection.bottom, ExpandDirection.top), throwsA(isA<Exception>()));
    });

    test('changeSize throws exception for invalid vertical direction', () {
      final tilemap = Tilemap(1, 1);
      expect(() => tilemap.changeSize(2, 2, ExpandDirection.left, ExpandDirection.right), throwsA(isA<Exception>()));
    });

    test('setTile sets the correct value at the given coordinates', () {
      final tilemap = Tilemap(3, 3);
      tilemap.setTile(0, 1, 2, 5);
      expect(tilemap.map[0][1][2], 5);
    });

    test('setTile expands width if x is out of bounds', () {
      final tilemap = Tilemap(2, 2);
      tilemap.setTile(0, 3, 1, 10);
      expect(tilemap.width, 4);
      expect(tilemap.map[0][3][1], 10);
      expect(tilemap.map[0][0].length, 2);
      expect(tilemap.map[0][1].length, 2);
      expect(tilemap.map[0][2].length, 2);
      expect(tilemap.map[0][3].length, 2);
    });

    test('setTile expands height if y is out of bounds', () {
      final tilemap = Tilemap(2, 2);
      tilemap.setTile(0, 1, 3, 15);
      expect(tilemap.height, 4);
      expect(tilemap.map[0][1][3], 15);
      expect(tilemap.map[0][0].length, 4);
      expect(tilemap.map[0][1].length, 4);
    });

    test('getTile returns the correct value at the given coordinates', () {
      final tilemap = Tilemap(3, 3);
      tilemap.setTile(1, 0, 2, 20);
      expect(tilemap.getTile(1, 0, 2), 20);
    });

    test('getTile returns 0 if x is out of bounds', () {
      final tilemap = Tilemap(2, 2);
      expect(tilemap.getTile(0, 2, 1), 0);
    });

    test('getTile returns 0 if y is out of bounds', () {
      final tilemap = Tilemap(2, 2);
      expect(tilemap.getTile(0, 1, 2), 0);
    });

    test('width getter returns the correct width', () {
      const width = 5;
      final tilemap = Tilemap(width, 2);
      expect(tilemap.width, width);
    });

    test('height getter returns the correct height', () {
      const height = 6;
      final tilemap = Tilemap(3, height);
      expect(tilemap.height, height);
    });
  });

  group('ComponentFieldTilemap', () {
    late Tilemap testTilemap;
    late List<Media> testMedias;
    late _MockComponentFieldTileset testTileset;

    setUp(() {
      // Initialiser une tilemap 2x2 simple
      testTilemap = Tilemap(2, 2);
      testTilemap.map[0][0][0] = 1;
      testTilemap.map[0][1][1] = 2;

      // Créer des médias de test conformes à la classe Media
      testMedias = [
        Media(id: 1, name: "Media 1"),
        Media(id: 2, name: "Media 2"),
      ];

      // Créer un tileset factice
      testTileset = _MockComponentFieldTileset(
        value: [
          _MockTile(id: 1, name: "Tile 1"),
          _MockTile(id: 2, name: "Tile 2"),
        ],
        onUpdate: () {},
      );
    });

    test('instance creates a deep copy', () {
      bool updateCalled = false;

      final original = ComponentFieldTilemap(
        value: testTilemap,
        onUpdate: () {
          updateCalled = true;
        },
      );

      final copy = original.instance();

      // Vérifier que c'est une nouvelle instance
      expect(identical(copy.value, original.value), false);

      // Vérifier que les valeurs sont identiques
      expect(copy.value.map[0][0][0], 1);
      expect(copy.value.map[0][1][1], 2);

      // Vérifier que le callback est copié
      copy.onUpdate!();
      expect(updateCalled, true);
    });

    test('value getter/setter works', () {
      final componentField = ComponentFieldTilemap(
        value: testTilemap,
        onUpdate: () {},
      );

      // Vérifier le getter
      expect(componentField.value.map[0][0][0], 1);

      // Créer une nouvelle tilemap et tester le setter
      final newTilemap = Tilemap(3, 3);
      newTilemap.map[0][0][0] = 3;
      componentField.value = newTilemap;

      expect(componentField.value.map[0][0][0], 3);
    });

    test('updateFromJson updates value correctly', () {
      final componentField = ComponentFieldTilemap(
        value: Tilemap(1, 1), // Initialiser avec une petite tilemap
        onUpdate: () {},
      );

      final jsonData = {
        'map': [
          [
            [1, 0],
            [0, 2]
          ]
        ]
      };

      componentField.updateFromJson(jsonData);

      expect(componentField.value.width, 2);
      expect(componentField.value.height, 2);
      expect(componentField.value.map[0][0][0], 1);
      expect(componentField.value.map[0][1][1], 2);
    });
  });
}