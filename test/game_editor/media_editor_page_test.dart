import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'package:plock_mobile/pages/my_games/game_editor/media_editor_page.dart';

void main() {
  group('MediaEditorPage', () {
    late Media testMedia;
    late Function(Media) toSetCallback;
    late MediaSet convertedMedia;

    setUp(() {
      testMedia = Media(id: 1, name: 'Test Media');
      toSetCallback = (media) {
        convertedMedia = MediaSet(id: media.id, name: media.name);
        convertedMedia.file = media.file;
        convertedMedia.tileWidth = 32;
        convertedMedia.tileHeight = 32;
        convertedMedia.offsetX = 0;
        convertedMedia.offsetY = 0;
        convertedMedia.gapX = 0;
        convertedMedia.gapY = 0;

        return convertedMedia;
      };
    });

    Widget createWidgetUnderTest(Media media) { // Add media parameter
      return MaterialApp(
        home: MediaEditorPage(
          media: media, // Use media parameter
          toSet: toSetCallback,
        ),
      );
    }

    testWidgets('displays media name and id', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testMedia)); // Pass testMedia

      expect(find.text('Test Media'), findsOneWidget);
      expect(find.text('id : 1'), findsOneWidget);
    });

    testWidgets('updates media name when text is entered',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest(testMedia)); // Pass testMedia

          await tester.enterText(find.byType(TextField), 'New Media Name');
          await tester.pumpAndSettle();

          expect(testMedia.name, 'New Media Name');
        });

    testWidgets('converts media to MediaSet when button is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest(testMedia)); // Pass testMedia

          await tester.tap(find.text('Convert To Tileset'));
          await tester.pumpAndSettle();

          expect(convertedMedia, isA<MediaSet>());
        });
  });
}