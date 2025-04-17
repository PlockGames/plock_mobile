import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/tileset/tileset_editor_page.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/component_fields/tileset/tileset_editor_page_loaded.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';

void main() {
  group('TilesetEditorPage Tests', () {
    late Tile tile;
    late List<Media> medias;
    late Media media;

    setUp(() {
      // Initialisation de Tile et Media avec un id
      tile = Tile();
      media = Media(
        id: 1,  // Ajout du paramètre id
        name: 'testMedia',
        // Ajoutez ici les autres paramètres nécessaires pour Media
      );
      medias = [media];

      // Définir une tuile avec un media correspondant
      tile.media = 'testMedia';
    });

    testWidgets('displays "No media found" when media is not found', (WidgetTester tester) async {
      // Changez le tile pour un media non trouvé
      tile.media = 'nonExistingMedia';
      medias = [media];

      await tester.pumpWidget(MaterialApp(
        home: TilesetEditorPage(
          tile: tile,
          medias: medias,
        ),
      ));

      // Attendre que le FutureBuilder se résolve
      await tester.pumpAndSettle();

      // Vérifiez que le texte "No media found" est affiché
      expect(find.text('No media found'), findsOneWidget);
    });

    testWidgets('shows loading indicator while image is loading', (WidgetTester tester) async {
      // Création d'une image factice pour simuler un chargement d'image
      final image = await createFakeImage();

      // Simuler une attente pour charger l'image
      await tester.pumpWidget(MaterialApp(
        home: TilesetEditorPage(
          tile: tile,
          medias: medias,
        ),
      ));

      // Vérifiez que l'indicateur de chargement est visible pendant l'attente
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

// Fonction pour créer une image factice (fake) pour les tests
Future<ui.Image> createFakeImage() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(100, 100)));

  canvas.drawRect(Rect.fromLTWH(0, 0, 100, 100), Paint()..color = Colors.blue);

  final picture = recorder.endRecording();
  final image = await picture.toImage(100, 100);  // Crée une image de 100x100 px
  return image;
}
