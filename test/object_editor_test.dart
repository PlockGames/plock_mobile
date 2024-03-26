import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/main.dart';

void main() {

  testWidgets('Check object edition page test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the object edition page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Verify that the add component icon button is displayed.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Change object name
    await tester.enterText(find.byType(TextField), 'New Object Name');
    await tester.pump();

    // Verify that the object name is changed.
    expect(find.text('New Object Name'), findsOneWidget);
  });

  testWidgets('Check add component test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the object edition page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Verify that the add component icon button is displayed.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the add component icon button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the add component page is displayed.
    expect(find.text('Add Component'), findsOneWidget);
    expect(find.text('Rectangle'), findsOneWidget);

    // Tap the add component icon button
    await tester.tap(find.text("Rectangle"));
    await tester.pump();

    // Verify that the edit component page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Veryfy that the component name is displayed.
    expect(find.text('Rectangle'), findsOneWidget);
  });

  testWidgets('Check remove component test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the object edition page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Verify that the add component icon button is displayed.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the add component icon button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the add component page is displayed.
    expect(find.text('Add Component'), findsOneWidget);
    expect(find.text('Rectangle'), findsOneWidget);

    // Tap the add component icon button
    await tester.tap(find.text("Rectangle"));
    await tester.pump();

    // Verify that the edit component page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Veryfy that the component name is displayed.
    expect(find.text('Rectangle'), findsOneWidget);

    // Tap the remove component icon button
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Verify that the object edition page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Verify that the component is removed.
    expect(find.text('Rectangle'), findsNothing);
  });

  testWidgets('Check edit component test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    // Verify that the object edition page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Verify that the add component icon button is displayed.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the add component icon button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the add component page is displayed.
    expect(find.text('Add Component'), findsOneWidget);
    expect(find.text('Rectangle'), findsOneWidget);

    // Tap the add component icon button
    await tester.tap(find.text("Rectangle"));
    await tester.pump();

    // Verify that the edit component page is displayed.
    expect(find.text('Object Editor'), findsOneWidget);

    // Veryfy that the component name is displayed.
    expect(find.text('Rectangle'), findsOneWidget);

    // Tap the edit component icon button
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Verify that the edit component page is displayed.
    expect(find.text('Edit Component'), findsOneWidget);

    // Change component name
    await tester.enterText(find.byType(TextField).first, '52');
    await tester.pump();

    // Verify that the component name is changed.
    expect(find.text('52'), findsOneWidget);
  });

}