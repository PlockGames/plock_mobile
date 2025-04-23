import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'package:plock_mobile/pages/my_games/game_editor/medias_page.dart';

void main() {
  group('MediasPage', () {
    late Game testGame;

    setUp(() {
      testGame = Game(name: 'Test Game');
      testGame.medias = [
        Media(id: 0, name: 'Media 1'),
        Media(id: 1, name: 'Media 2'),
      ];
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: MediasPage(game: testGame),
      );
    }

    testWidgets('displays media names', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Media 1'), findsOneWidget);
      expect(find.text('Media 2'), findsOneWidget);
    });

    testWidgets('adds a new media when the add button is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();

          expect(testGame.medias.length, 3);
          expect(find.text('New Media'), findsOneWidget);
        });

    testWidgets('removes a media when the delete button is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.delete).first);
          await tester.pumpAndSettle();

          expect(testGame.medias.length, 1);
          expect(find.text('Media 1'), findsNothing);
        });

    testWidgets('navigates to MediaEditorPage when a media is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());
          await tester.pumpAndSettle();

          await tester.tap(find.text('Media 1'));
          await tester.pumpAndSettle();

          expect(find.text('Media Editor'), findsOneWidget);
        });

    testWidgets('converts media to MediaSet', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Media 1'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Convert To Tileset'));
      await tester.pumpAndSettle();

      expect(testGame.medias[0], isA<MediaSet>());
    });
  });
}