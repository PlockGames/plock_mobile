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
import 'dart:async'; // Import the dart:async library

void main() {
  group('ComponentFieldTilesetField Widget Tests', () {
    late List<Tile> testTiles;
    late List<Media> testMedias;
    late ComponentFieldTileset testComponentFieldTileset;
    late void Function() onUpdateCallback;

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

      // Créer un mock de la fonction onUpdate
      onUpdateCallback = () {};

      // Créer une instance de ComponentFieldTileset pour le widget
      testComponentFieldTileset = ComponentFieldTileset(
        value: testTiles,
        onUpdate: onUpdateCallback,
      );
    });

    Widget createWidgetUnderTest({required ComponentFieldTileset field, List<Media> medias = const []}) {
      return MaterialApp(
        home: Scaffold(
          body: ComponentFieldTilesetField(
            field: field,
            name: 'testTileset',
            medias: medias,
            onUpdate: onUpdateCallback,
          ),
        ),
      );
    }

    testWidgets('renders initial tiles correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(field: testComponentFieldTileset, medias: testMedias));
      await tester.pumpAndSettle(); // Wait for FutureBuilder

      expect(find.text('media1'), findsOneWidget);
      expect(find.text('media2'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byIcon(Icons.edit), findsNWidgets(2));
      expect(find.byIcon(Icons.delete), findsNWidgets(2));
      expect(find.byType(FilledButton), findsOneWidget); // Add button
    });

    testWidgets('updates tile media when text field loses focus', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(field: testComponentFieldTileset, medias: testMedias));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byType(TextField).first;
      await tester.enterText(textFieldFinder, 'new_media');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(testComponentFieldTileset.value[0].media, 'new_media');
    });

    testWidgets('removes tile when delete button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(field: testComponentFieldTileset, medias: testMedias));
      await tester.pumpAndSettle();

      expect(testComponentFieldTileset.value.length, 2);
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(testComponentFieldTileset.value.length, 1);
      expect(find.text('media1'), findsNothing);
    });

    testWidgets('adds new tile when add button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(field: testComponentFieldTileset, medias: testMedias));
      await tester.pumpAndSettle();

      expect(testComponentFieldTileset.value.length, 2);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(testComponentFieldTileset.value.length, 3);
      expect(find.byType(TextField), findsNWidgets(3));
    });


    testWidgets('displays empty text if media is null', (WidgetTester tester) async {
      final nullMediaTileset = ComponentFieldTileset(value: [Tile()..media = "non_existent_media"], onUpdate: () {});
      await tester.pumpWidget(createWidgetUnderTest(field: nullMediaTileset, medias: testMedias));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsNothing);
      expect(find.text(''), findsOneWidget);
    });
  });
}