import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plock_mobile/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Page Tests', () {
    testWidgets('Affichage des informations du profil',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text("Mon Profil"), findsOneWidget);
      expect(find.text("Nom d'utilisateur"), findsOneWidget);
      expect(find.text("Email"), findsOneWidget);
      expect(find.text("Téléphone"), findsOneWidget);
      expect(find.text("Date de naissance"), findsOneWidget);
    });

    testWidgets('Modification du nom d\'utilisateur',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ListTile, "Nom d'utilisateur"));
      await tester.pumpAndSettle();

      expect(find.text("Modifier Nom d'utilisateur"), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), "NouveauNom");

      await tester.tap(find.text("Enregistrer"));
      await tester.pumpAndSettle();

      expect(find.text("NouveauNom"), findsOneWidget);
    });

    testWidgets('Modification de l\'email', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ListTile, "Email"));
      await tester.pumpAndSettle();

      expect(find.text("Modifier Email"), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), "nouveau@mail.com");

      await tester.tap(find.text("Enregistrer"));
      await tester.pumpAndSettle();

      expect(find.text("nouveau@mail.com"), findsOneWidget);
    });

    testWidgets('Sélection d\'une image de profil',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle();

      // TO DO: ImagePicker
    });

    testWidgets('Modification de la date de naissance',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ListTile, "Date de naissance"));
      await tester.pumpAndSettle();

      expect(find.text("Modifier Date de naissance"), findsOneWidget);

      // TO DO: `showDatePicker` mocké
      // TO DO: `tester.tap(find.byIcon(Icons.calendar_today))`
    });
  });
}
