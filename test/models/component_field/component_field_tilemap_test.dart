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

// Classe factice pour Tile si elle n'est pas disponible
class _MockTile {
  final int id;
  final String name;
  String? media;
  List<bool> collision = [];

  _MockTile({required this.id, required this.name, this.media});
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

  @override
  dynamic get dynamicValue => value;
}

void main() {
  group('ComponentFieldTilemap', () {
    late Tilemap testTilemap;
    late List<Media> testMedias;
    late _MockComponentFieldTileset testTileset;
    late VoidCallback onUpdateCallback;

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
          _MockTile(id: 1, name: "Tile 1", media: "media1"),
          _MockTile(id: 2, name: "Tile 2", media: "media2"),
        ],
        onUpdate: () {},
      );

      // Mock du callback onUpdate
      onUpdateCallback = () {};
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
        onUpdate: onUpdateCallback,
      );

      // Vérifier le getter
      expect(componentField.value.map[0][0][0], 1);

      // Créer une nouvelle tilemap et tester le setter
      final newTilemap = Tilemap(3, 3);
      newTilemap.map[0][0][0] = 3;
      componentField.value = newTilemap;

      expect(componentField.value.map[0][0][0], 3);
    });

    test('type getter returns correct type', () {
      final componentField = ComponentFieldTilemap(
        value: testTilemap,
        onUpdate: onUpdateCallback,
      );

      expect(componentField.type, 'ComponentFieldText');
    });



    test('updateFromJson updates value correctly', () {
      final componentField = ComponentFieldTilemap(
        value: Tilemap(1, 1), // Initialiser avec une petite tilemap
        onUpdate: onUpdateCallback,
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

  group('ComponentFieldTilemapField Widget Tests', () {
    late Tilemap testTilemap;
    late List<Media> testMedias;
    late List<Tile> testTiles; // Use the actual Tile class
    late VoidCallback onUpdateCallback;

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

      // Créer un tileset factice using the actual Tile class
      testTiles = [
        Tile()..media = "media1",
        Tile()..media = "media2",
      ];

      // Mock du callback onUpdate
      onUpdateCallback = () {};
    });

    Widget createWidgetUnderTest({required ComponentFieldTilemap field, Function()? onUpdate}) {
      return MaterialApp(
        home: Scaffold(
          body: ComponentFieldTilemapField(
            field: field,
            name: 'TilemapField',
            medias: testMedias,
            tiles: testTiles,
            onUpdate: onUpdate,
          ),
        ),
      );
    }

    testWidgets('renders a FilledButton with correct text', (WidgetTester tester) async {
      final field = ComponentFieldTilemap(value: testTilemap, onUpdate: onUpdateCallback);
      await tester.pumpWidget(createWidgetUnderTest(field: field, onUpdate: onUpdateCallback));

      expect(find.widgetWithText(FilledButton, "Edit tilemap"), findsOneWidget);
    });

  });
}