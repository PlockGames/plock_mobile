
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/main.dart';

/// This file is used to test the MyGamesPage widget
/// TODO: Add navigation when navbar will be implemented
void main() {

  testWidgets('Create a game test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify page content
    expect(find.text('Mes projets'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the popup is displayed
    expect(find.text('Nouveau jeu'), findsOneWidget);
    expect(find.text('Retour'), findsOneWidget);
    expect(find.text('Créer'), findsOneWidget);

    // Modify the textfield
    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pump();

    // Tap the 'Créer' button and trigger a frame.
    await tester.tap(find.text('Créer'));
    await tester.pump();

    // Verify that the game is created and that the game edition page is displayed
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('Edit a game test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify page content
    expect(find.text('Mes projets'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Modify the textfield
    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pump();

    // Tap the 'Créer' button and trigger a frame.
    await tester.tap(find.text('Créer'));
    await tester.pump();

    // Verify that the game is created and that the game edition page is displayed
    expect(find.text('Test'), findsOneWidget);

    // go back to the games page
    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
    await widgetsAppState.didPopRoute();
    await tester.pump();

    // Tap the 'edit' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();

    // Verify that the game edition page is displayed
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('Delete a game test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify page content
    expect(find.text('Mes projets'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Modify the textfield
    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pump();

    // Tap the 'Créer' button and trigger a frame.
    await tester.tap(find.text('Créer'));
    await tester.pump();

    // Verify that the game is created and that the game edition page is displayed
    expect(find.text('Test'), findsOneWidget);

    // go back to the games page
    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
    await widgetsAppState.didPopRoute();
    await tester.pump();

    // Tap the 'delete' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    // Verify that the game is deleted
    expect(find.text('Test'), findsNothing);
  });


}