import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Assurez-vous d’importer le bon chemin de votre page ProfilePage
import 'package:plock_mobile/pages/my_games/my_profile_page.dart';

void main() {
  group('Tests de ProfilePage', () {
    testWidgets('Affichage des informations par défaut', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Vérifie que l'appBar affiche le titre "Mon Profil"
      expect(find.text('Mon Profil'), findsOneWidget);

      // Vérifie que l'avatar par défaut affiche l'icône de la personne
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Vérifie que chaque champ est affiché avec sa valeur par défaut
      expect(find.text('Prénom'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);

      expect(find.text('Nom'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);

      expect(find.text("Nom d'utilisateur"), findsOneWidget);
      expect(find.text('johndoe'), findsOneWidget);

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('johndoe@example.com'), findsOneWidget);

      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('********'), findsOneWidget);

      expect(find.text('Téléphone'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);

      expect(find.text('Date de naissance'), findsOneWidget);
      expect(find.text('01/01/2000'), findsOneWidget);
    });

    testWidgets("Modification d'un champ via le dialogue d'édition", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Taper sur le premier icône d'édition (celui associé à "Prénom")
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      // Vérifie que le dialogue s'ouvre avec le titre "Modifier Prénom"
      expect(find.text('Modifier Prénom'), findsOneWidget);

      // Modifier le champ en entrant "Jane" dans le TextFormField
      await tester.enterText(find.byType(TextFormField), 'Jane');

      // Enregistrer la modification
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      // Vérifie que le prénom est mis à jour dans l'interface
      expect(find.text('Jane'), findsOneWidget);
    });

    testWidgets("Annulation de la modification d'un champ", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Pour modifier "Nom", qui est le deuxième champ, on cible le deuxième icône d'édition
      final editIcons = find.byIcon(Icons.edit);
      expect(editIcons, findsNWidgets(7)); // 7 champs éditables
      await tester.tap(editIcons.at(1));
      await tester.pumpAndSettle();

      // Vérifie que le dialogue s'ouvre avec le titre "Modifier Nom"
      expect(find.text('Modifier Nom'), findsOneWidget);

      // Entrer une nouvelle valeur "Smith" mais annuler ensuite
      await tester.enterText(find.byType(TextFormField), 'Smith');
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Vérifie que le nom reste inchangé ("Doe")
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('Smith'), findsNothing);
    });

    testWidgets("Interaction avec l'image de profil sans sélection d'image", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Taper sur la zone de l'image (CircleAvatar)
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Comme aucune image n'est sélectionnée, l'icône par défaut doit rester affichée
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
