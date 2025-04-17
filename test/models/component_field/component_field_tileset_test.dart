import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/tileset/tileset_editor_page.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/component_fields/tileset/tileset_editor_page_loaded.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';
import 'dart:typed_data';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/component_fields/component_field_tileset.dart';


void main() {
  group('ComponentFieldTileset', () {
    late List<Tile> testTiles;
    late List<Media> testMedias;

    setUp(() {
      // Initialiser des tiles de test
      testTiles = [
        Tile()
          ..media = "media1"
          ..collision = [false, true],
        Tile()
          ..media = "media2"
          ..collision = [true, false],
      ];

      // Créer des médias de test
      testMedias = [
        Media(id: 1, name: "media1"),
        Media(id: 2, name: "media2"),
      ];
    });

    test('instance creates a deep copy', () {
      final original = ComponentFieldTileset(
        value: testTiles,
        onUpdate: () {},
      );

      final copy = original.instance();

      // Vérifier que c'est une nouvelle instance
      expect(identical(copy.value, original.value), false);

      // Vérifier que les valeurs sont identiques
      expect(copy.value[0].media, "media1");
      expect(copy.value[0].collision, [false, true]);
      expect(copy.value[1].media, "media2");
      expect(copy.value[1].collision, [true, false]);
    });

    test('value getter/setter works', () {
      final componentField = ComponentFieldTileset(
        value: testTiles,
        onUpdate: () {},
      );

      // Vérifier le getter
      expect(componentField.value.length, 2);

      // Tester le setter
      final newTiles = [Tile()..media = "new_media"];
      componentField.value = newTiles;
      expect(componentField.value.length, 1);
      expect(componentField.value[0].media, "new_media");
    });

    test('toJson returns correct JSON', () {
      final componentField = ComponentFieldTileset(
        value: testTiles,
        onUpdate: () {},
      );

      final json = componentField.toJson();
      expect(json, contains('"media": "media1"'));
      expect(json, contains('"collision": [false,true]'));
      expect(json, contains('"media": "media2"'));
      expect(json, contains('"collision": [true,false]'));
    });

    test('updateFromJson updates value correctly', () {
      final componentField = ComponentFieldTileset(
        value: [],
        onUpdate: () {},
      );

      final jsonData = [
        {
          "media": "json_media1",
          "collision": [true, false]
        },
        {
          "media": "json_media2",
          "collision": [false, true]
        }
      ];

      componentField.updateFromJson(jsonData);

      expect(componentField.value.length, 2);
      expect(componentField.value[0].media, "json_media1");
      expect(componentField.value[0].collision, [true, false]);
      expect(componentField.value[1].media, "json_media2");
      expect(componentField.value[1].collision, [false, true]);
    });
  });

}