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

      // Vérifier que la modification de la copie n'affecte pas l'original
      copy.value[0].media = "modified";
      expect(copy.value[0].media, "modified");
      expect(original.value[0].media, "media1");
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

    // Nouveau test: vérifier que type renvoie la bonne valeur
    test('type getter returns correct type', () {
      final componentField = ComponentFieldTileset(
        value: testTiles,
        onUpdate: () {},
      );

      expect(componentField.type, 'ComponentFieldTileset');
    });

    // Nouveau test: vérifier que toJson gère correctement les cas limites
    test('toJson handles edge cases properly', () {
      // Cas avec des tiles sans collision
      final emptyCollisionTiles = [
        Tile()
          ..media = "media1"
          ..collision = [],
      ];

      final emptyComponentField = ComponentFieldTileset(
        value: emptyCollisionTiles,
        onUpdate: () {},
      );

      final emptyJson = emptyComponentField.toJson();
      expect(emptyJson, contains('"media": "media1"'));
      expect(emptyJson, contains('"collision": []'));

      // Cas avec aucun tile
      final noTiles = <Tile>[];

      final emptyTilesField = ComponentFieldTileset(
        value: noTiles,
        onUpdate: () {},
      );

      final emptyTilesJson = emptyTilesField.toJson();
      expect(emptyTilesJson, '[]');
    });

    // Nouveau test: vérifier que updateFromJson gère correctement les cas limites
    test('updateFromJson handles edge cases properly', () {
      final componentField = ComponentFieldTileset(
        value: testTiles,
        onUpdate: () {},
      );

      // Cas avec un tableau vide
      final emptyJsonData = [];
      componentField.updateFromJson(emptyJsonData);
      expect(componentField.value.length, 0);

      // Cas avec un tableau contenant un élément avec collision vide
      final jsonDataWithEmptyCollision = [
        {
          "media": "empty_collision",
          "collision": []
        }
      ];

      componentField.updateFromJson(jsonDataWithEmptyCollision);
      expect(componentField.value.length, 1);
      expect(componentField.value[0].media, "empty_collision");
      expect(componentField.value[0].collision, []);
    });

    // Nouveau test: vérifier le fonctionnement du callback onUpdate
    test('onUpdate callback works correctly', () {
      bool callbackCalled = false;

      final componentField = ComponentFieldTileset(
        value: testTiles,
        onUpdate: () {
          callbackCalled = true;
        },
      );

      // Appeler le callback directement
      if (componentField.onUpdate != null) {
        componentField.onUpdate!();
      }

      expect(callbackCalled, true);
    });

    // Nouveau test: vérifier que la méthode getField renvoie le bon widget
    test('getField returns correct widget', () {
      final componentField = ComponentFieldTileset(
        value: testTiles,
        onUpdate: () {},
      );

      final widget = componentField.getField('TestField', false, testMedias, {});

      expect(widget, isA<ComponentFieldTilesetField>());
      expect((widget as ComponentFieldTilesetField).name, 'TestField');
      expect(widget.field, componentField);
    });

    // Tests pour la classe ComponentFieldTilesetField
    group('ComponentFieldTilesetField', () {
      testWidgets('initializes properly', (WidgetTester tester) async {
        // Mock minimal MaterialApp wrapper for testing
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: ComponentFieldTilesetField(
              field: ComponentFieldTileset(value: testTiles, onUpdate: () {}),
              name: 'TestField',
              medias: testMedias,
            ),
          ),
        ));

        // Vérifier que le widget se construit correctement
        expect(find.byType(ComponentFieldTilesetField), findsOneWidget);

        // Le FutureBuilder peut être en chargement initialement
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });

      testWidgets('renders tiles correctly after loading', (WidgetTester tester) async {
        // Créer un mock Media avec une méthode getNbTiles simulée
        final mockMedia1 = Media(id: 1, name: "media1");
        final mockMedia2 = Media(id: 2, name: "media2");

        final mockMedias = [mockMedia1, mockMedia2];

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: ComponentFieldTilesetField(
              field: ComponentFieldTileset(value: testTiles, onUpdate: () {}),
              name: 'TestField',
              medias: mockMedias,
            ),
          ),
        ));

        // Attendre que le FutureBuilder termine
        await tester.pumpAndSettle();

        // Vérifier les TextFields pour les médias
        expect(find.byType(TextField), findsNWidgets(2));

        // Vérifier les boutons d'édition et de suppression
        expect(find.byIcon(Icons.edit), findsNWidgets(2));
        expect(find.byIcon(Icons.delete), findsNWidgets(2));

        // Vérifier le bouton d'ajout
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('add button adds a new tile', (WidgetTester tester) async {
        bool onUpdateCalled = false;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: ComponentFieldTilesetField(
              field: ComponentFieldTileset(
                  value: testTiles,
                  onUpdate: () {
                    onUpdateCalled = true;
                  }
              ),
              name: 'TestField',
              medias: testMedias,
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Nombre initial de TextFields
        final int initialFieldCount = find.byType(TextField).evaluate().length;

        // Appuyer sur le bouton d'ajout
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Vérifier qu'un nouveau TextField a été ajouté
        expect(find.byType(TextField), findsNWidgets(initialFieldCount + 1));

        // Vérifier que le callback onUpdate a été appelé
        expect(onUpdateCalled, true);
      });

      testWidgets('delete button removes a tile', (WidgetTester tester) async {
        bool onUpdateCalled = false;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: ComponentFieldTilesetField(
              field: ComponentFieldTileset(
                  value: testTiles,
                  onUpdate: () {
                    onUpdateCalled = true;
                  }
              ),
              name: 'TestField',
              medias: testMedias,
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Nombre initial de TextFields
        final int initialFieldCount = find.byType(TextField).evaluate().length;

        // Appuyer sur le premier bouton de suppression
        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pumpAndSettle();

        // Vérifier qu'un TextField a été supprimé
        expect(find.byType(TextField), findsNWidgets(initialFieldCount - 1));

        // Vérifier que le callback onUpdate a été appelé
        expect(onUpdateCalled, true);
      });
    });
  });
}