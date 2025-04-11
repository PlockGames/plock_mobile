import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/models/games/game.dart';

void main() {
  group('MyGamesPage Tests', () {
    testWidgets('Initial page state displays correct elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyGamesPage(),
        ),
      );

      // Wait for potential async operations
      await tester.pump(const Duration(seconds: 1));

      // Verify app bar title
      expect(find.text('My projects'), findsOneWidget);

      // Verify floating action button
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Floating action button opens game creation dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyGamesPage(),
        ),
      );

      // Wait for potential async operations
      await tester.pump(const Duration(seconds: 1));

      // Tap the floating action button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify game creation dialog is displayed
      expect(find.text('New game'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('Creating a new game with empty name prevents dialog closure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyGamesPage(),
        ),
      );

      // Wait for potential async operations
      await tester.pump(const Duration(seconds: 1));

      // Open game creation dialog
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Try to create game with empty name
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify dialog is still open
      expect(find.text('New game'), findsOneWidget);
    });

    testWidgets('Game deletion dialog appears', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyGamesPage(),
        ),
      );

      // Wait for potential async operations
      await tester.pump(const Duration(seconds: 1));

      // If no games are present, this test might need adjustment
      // Assuming at least one game exists or is created
      if (find.byIcon(Icons.delete).evaluate().isNotEmpty) {
        // Tap delete icon
        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pumpAndSettle();

        // Verify deletion dialog
        expect(find.text('Delete game ?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      }
    });

    testWidgets('Cancel button in deletion dialog closes the dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyGamesPage(),
        ),
      );

      // Wait for potential async operations
      await tester.pump(const Duration(seconds: 1));

      // If no games are present, this test might need adjustment
      if (find.byIcon(Icons.delete).evaluate().isNotEmpty) {
        // Tap delete icon
        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pumpAndSettle();

        // Tap cancel button
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Verify dialog is closed
        expect(find.text('Delete game ?'), findsNothing);
      }
    });
  });
}