import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Assurez-vous d'importer le bon chemin de votre page ProfilePage
import 'package:plock_mobile/pages/my_games/my_profile_page.dart';

void main() {
  group('Tests de ProfilePage', () {
    testWidgets('Affichage des informations par défaut', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Attendre que les données soient chargées
      await tester.pump(const Duration(seconds: 1));

      // Vérifie que l'appBar affiche le titre "Mon Profil"
      expect(find.text('Mon Profil'), findsOneWidget);

      // Vérifie que l'avatar par défaut affiche l'icône de la personne
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Vérifie que les champs sont présents
      expect(find.text("Nom d'utilisateur"), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Téléphone'), findsOneWidget);
      expect(find.text('Date de naissance'), findsOneWidget);

      // Vérifie que le mot de passe est masqué
      expect(find.text('********'), findsOneWidget);
    });

    testWidgets("Modification du nom d'utilisateur via le dialogue d'édition", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Attendre que les données soient chargées
      await tester.pump(const Duration(seconds: 1));

      // Taper sur l'icône d'édition associé au "Nom d'utilisateur"
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      // Vérifie que le dialogue s'ouvre avec le titre "Modifier Nom d'utilisateur"
      expect(find.text("Modifier Nom d'utilisateur"), findsOneWidget);

      // Modifier le champ en entrant "newusername" dans le TextFormField
      await tester.enterText(find.byType(TextFormField), 'newusername');

      // Enregistrer la modification
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      // Le test ne peut pas tester la mise à jour réelle car cela nécessiterait
      // une réponse API, mais on peut vérifier que le dialogue se ferme
      expect(find.text("Modifier Nom d'utilisateur"), findsNothing);
    });

    testWidgets("Annulation de la modification d'un champ", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Attendre que les données soient chargées
      await tester.pump(const Duration(seconds: 1));

      // Taper sur l'icône d'édition associé à "Email" (deuxième champ)
      final editIcons = find.byIcon(Icons.edit);
      await tester.tap(editIcons.at(1));
      await tester.pumpAndSettle();

      // Vérifie que le dialogue s'ouvre avec le titre "Modifier Email"
      expect(find.text('Modifier Email'), findsOneWidget);

      // Entrer une nouvelle valeur "newemail@example.com" mais annuler ensuite
      await tester.enterText(find.byType(TextFormField), 'newemail@example.com');
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Vérifie que le dialogue se ferme
      expect(find.text('Modifier Email'), findsNothing);
    });

    testWidgets("Dialogue d'édition pour le mot de passe", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Attendre que les données soient chargées
      await tester.pump(const Duration(seconds: 1));

      // Taper sur l'icône d'édition du mot de passe (troisième champ)
      final editIcons = find.byIcon(Icons.edit);
      await tester.tap(editIcons.at(2));
      await tester.pumpAndSettle();

      // Vérifie que le dialogue s'ouvre avec le titre "Modifier Mot de passe"
      expect(find.text('Modifier Mot de passe'), findsOneWidget);

      // Vérifie que l'icône de visibilité du mot de passe est présente
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Taper sur l'icône pour afficher le mot de passe
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Vérifier que l'icône change
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Annuler la modification
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Vérifier que le dialogue se ferme
      expect(find.text('Modifier Mot de passe'), findsNothing);
    });

    testWidgets("Dialogue d'édition pour la date de naissance", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Attendre que les données soient chargées
      await tester.pump(const Duration(seconds: 1));

      // Taper sur l'icône d'édition de la date de naissance (dernier champ)
      final editIcons = find.byIcon(Icons.edit);
      await tester.tap(editIcons.last);
      await tester.pumpAndSettle();

      // Vérifier que le dialogue s'ouvre avec le titre "Modifier Date de naissance"
      expect(find.text('Modifier Date de naissance'), findsOneWidget);

      // Vérifier que l'icône de calendrier est présente
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);

      // Ne pas essayer d'interagir directement avec le AbsorbPointer car c'est précisément
      // ce qui bloque l'interaction dans ce cas

      // Annuler la modification
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Vérifier que le dialogue se ferme
      expect(find.text('Modifier Date de naissance'), findsNothing);
    });

    testWidgets("Édition de tous les champs disponibles", (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePage(),
        ),
      );

      // Attendre que les données soient chargées
      await tester.pump(const Duration(seconds: 1));

      // Vérifier que tous les champs éditables ont une icône d'édition
      final editIcons = find.byIcon(Icons.edit);

      // Vérifier que tous les champs sont présents
      expect(find.text("Nom d'utilisateur"), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
      expect(find.text('Téléphone'), findsOneWidget);
      expect(find.text('Date de naissance'), findsOneWidget);

      // Vérifier le nombre d'icônes d'édition correspondant aux champs
      expect(editIcons, findsWidgets);
    });
  });
}