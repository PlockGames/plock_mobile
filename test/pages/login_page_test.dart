import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:plock_mobile/services/auth_service.dart';
import 'package:plock_mobile/pages/login_page.dart';

// Génère les mocks avec Mockito
@GenerateMocks([AuthService])
import 'login_page_test.mocks.dart';

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  // Fonction utilitaire pour configurer le widget de test sans mock
  Widget createLoginScreen() => MaterialApp(
    home: LoginPage(),
    routes: {
      '/home': (context) => const Scaffold(body: Text('Home Page')),
      '/register': (context) => const Scaffold(body: Text('Register Page')),
    },
  );

  // Fonction utilitaire pour configurer le widget de test avec mock
  Widget createTestableLoginScreen() => MaterialApp(
    home: LoginPage(authService: mockAuthService),
    routes: {
      '/home': (context) => const Scaffold(body: Text('Home Page')),
      '/register': (context) => const Scaffold(body: Text('Register Page')),
    },
  );

  group('LoginPage Widget Tests', () {
    testWidgets('Should render all form fields and buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      // Vérifier que les champs email et mot de passe sont rendus
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Vérifier que les boutons sont rendus
      expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);
      expect(find.text('Don\'t have an account? Register'), findsOneWidget);
    });

    testWidgets('Should show validation errors when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      // Trouver le bouton de connexion et cliquer dessus sans remplir les champs
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pump();

      // Vérifier qu'un message d'erreur est affiché
      expect(find.text('Email and password are required.'), findsOneWidget);
    });

    testWidgets('Should show error for invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      // Entrer un email invalide et un mot de passe
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'invalid-email');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');

      // Cliquer sur le bouton de connexion
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pump();

      // Vérifier qu'un message d'erreur sur le format email est affiché
      expect(find.text('Invalid email format.'), findsOneWidget);
    });

    testWidgets('Should navigate to register page when register link is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());

      // Cliquer sur le lien d'inscription
      await tester.tap(find.text('Don\'t have an account? Register'));
      await tester.pumpAndSettle(); // Attendre toutes les animations

      // Vérifier la navigation vers la page Register
      expect(find.text('Register Page'), findsOneWidget);
    });
  });

  group('LoginPage - AuthService Integration Tests', () {
    testWidgets('Should show error message when login fails', (WidgetTester tester) async {
      // Configurer le mock pour échouer
      when(mockAuthService.login(any, any)).thenAnswer((_) async => {
        'success': false,
        'message': 'Invalid email or password',
      });

      await tester.pumpWidget(createTestableLoginScreen());

      // Entrer des identifiants
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'wrongpassword');

      // Cliquer sur le bouton de connexion
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));

      // Premier pump après le tap
      await tester.pump();
      // Deuxième pump pour afficher le SnackBar de chargement
      await tester.pump();
      // Troisième pump pour le changement après l'appel à login
      await tester.pump();

      // Vérifier que le message d'erreur est bien présent dans le widget tree
      expect(tester.widget<SnackBar>(find.byType(SnackBar)).content, isA<Text>());
      final textWidget = tester.widget<Text>(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.byType(Text),
          )
      );
      expect(textWidget.data, 'Invalid email or password');
    });

    testWidgets('Should navigate to home on successful login', (WidgetTester tester) async {
      // Configurer le mock pour réussir
      when(mockAuthService.login(any, any)).thenAnswer((_) async => {
        'success': true,
        'message': 'Login successful',
        'data': {'accessToken': 'fake-token', 'refreshToken': 'fake-refresh-token'}
      });

      await tester.pumpWidget(createTestableLoginScreen());

      // Entrer des identifiants valides
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');

      // Cliquer sur le bouton de connexion
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pumpAndSettle(); // Attendre toutes les animations

      // Vérifier la navigation vers la page Home
      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('Should show loading indicator during login process', (WidgetTester tester) async {
      // Créer un Completer pour contrôler la résolution de la Future
      final completer = Completer<Map<String, dynamic>>();

      // Configurer le mock pour utiliser le Completer
      when(mockAuthService.login(any, any)).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestableLoginScreen());

      // Entrer des identifiants valides
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');

      // Cliquer sur le bouton de connexion
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pump();

      // Vérifier que le SnackBar de chargement est affiché
      expect(find.byType(SnackBar), findsOneWidget);
      final snackBarText = tester.widget<Text>(
          find.descendant(
            of: find.byType(SnackBar),
            matching: find.byType(Text),
          )
      );
      expect(snackBarText.data, 'Logging in...');

      // Compléter le future pour éviter des erreurs de Timer en attente
      completer.complete({
        'success': true,
        'message': 'Login successful',
        'data': {'accessToken': 'fake-token', 'refreshToken': 'fake-refresh-token'}
      });

      // Finaliser les animations
      await tester.pumpAndSettle();
    });
  });
}
