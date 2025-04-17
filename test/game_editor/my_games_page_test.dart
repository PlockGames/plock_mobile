import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/services/api.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MyGamesPage(),
    );
  }

  testWidgets('MyGamesPage affiche le titre et le bouton d\'ajout', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('My projects'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('MyGamesPage ouvre le dialogue de création de jeu', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('New game'), findsOneWidget);
  });
}