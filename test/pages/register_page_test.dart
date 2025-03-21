import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:plock_mobile/services/auth_service.dart';

// Importer le widget RegisterPage
import 'package:plock_mobile/pages/register_page.dart';

// Générer le mock de AuthService
@GenerateNiceMocks([MockSpec<AuthService>(), MockSpec<NavigatorObserver>()])
import 'register_page_test.mocks.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockNavigatorObserver mockNavigatorObserver;

  // Wrap RegisterPage dans un widget testable
  Widget createRegisterPage() {
    return MaterialApp(
      home: RegisterPage(authService: mockAuthService),
      navigatorObservers: [mockNavigatorObserver],
      routes: {
        '/home': (context) => const Scaffold(body: Center(child: Text('Home Page'))),
        '/login': (context) => const Scaffold(body: Center(child: Text('Login Page'))),
      },
    );
  }

  setUp(() {
    mockAuthService = MockAuthService();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  group('RegisterPage - UI Tests', () {
    testWidgets('shows all form fields', (WidgetTester tester) async {
      // Définir une taille d'écran plus grande pour le test
      tester.binding.window.physicalSizeTestValue = const Size(800, 900);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      // Création du widget
      await tester.pumpWidget(createRegisterPage());

      // Vérification de la présence de tous les champs du formulaire en cherchant par labelText
      expect(find.widgetWithText(TextField, 'First Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Last Name'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Date of Birth (YYYY-MM-DD)'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Phone Number (Optional)'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

      // Vérification de la présence du bouton d'inscription
      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);

      // Faire défiler vers le bas pour trouver le lien de connexion
      await tester.dragUntilVisible(
        find.text('Already have an account? Log in'),
        find.byType(SingleChildScrollView),
        const Offset(0, 50), // Faire défiler vers le bas
      );

      // Vérification de la présence du lien vers la page de connexion
      expect(find.text('Already have an account? Log in'), findsOneWidget);
    });

    testWidgets('tapping login link navigates to login page', (WidgetTester tester) async {
      // Définir une taille d'écran plus grande pour le test
      tester.binding.window.physicalSizeTestValue = const Size(800, 900);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      // Création du widget
      await tester.pumpWidget(createRegisterPage());

      // Faire défiler vers le bas pour trouver le lien de connexion
      await tester.dragUntilVisible(
        find.text('Already have an account? Log in'),
        find.byType(SingleChildScrollView),
        const Offset(0, 50),
      );

      // Clic sur le lien de connexion
      await tester.tap(find.text('Already have an account? Log in'));
      await tester.pumpAndSettle();

      // Vérification de la navigation
      verify(mockNavigatorObserver.didPush(any, any));
    });

    testWidgets('shows date picker when calendar icon is tapped', (WidgetTester tester) async {
      // Création du widget
      await tester.pumpWidget(createRegisterPage());

      // Localisation et clic sur l'icône du calendrier
      await tester.tap(find.byIcon(Icons.date_range));
      await tester.pumpAndSettle();

      // Vérification que le DatePicker est affiché
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });

  group('RegisterPage - Validation Tests', () {
    testWidgets('validates empty fields', (WidgetTester tester) async {
      // Création du widget
      await tester.pumpWidget(createRegisterPage());

      // Clic sur le bouton d'inscription sans remplir de champs
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();

      // Vérification du message d'erreur
      expect(find.text('All mandatory fields must be filled.'), findsOneWidget);
    });

    testWidgets('validates email format', (WidgetTester tester) async {
      // Création du widget
      await tester.pumpWidget(createRegisterPage());

      // Remplissage des champs avec un email invalide
      await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'John');
      await tester.enterText(find.widgetWithText(TextField, 'Last Name'), 'Doe');
      await tester.enterText(find.widgetWithText(TextField, 'Username'), 'johndoe');
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'invalid-email');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.enterText(find.widgetWithText(TextField, 'Date of Birth (YYYY-MM-DD)'), '1990-01-01');

      // Clic sur le bouton d'inscription
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();

      // Vérification du message d'erreur
      expect(find.text('Invalid email format.'), findsOneWidget);
    });
  });

  group('RegisterPage - Registration Process Tests', () {
    testWidgets('successful registration shows success message and navigates to home',
            (WidgetTester tester) async {
          // Configuration des mocks
          when(mockAuthService.signup(any)).thenAnswer((_) async => {
            'success': true,
            'message': 'Signup successful',
            'data': {'accessToken': 'fake_token', 'refreshToken': 'fake_refresh_token'}
          });

          when(mockAuthService.completeSignup(any)).thenAnswer((_) async => {
            'success': true,
            'message': 'Registration completed successfully',
            'data': {'accessToken': 'new_token', 'refreshToken': 'new_refresh_token'}
          });

          // Création du widget
          await tester.pumpWidget(createRegisterPage());

          // Remplissage de tous les champs
          await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'John');
          await tester.enterText(find.widgetWithText(TextField, 'Last Name'), 'Doe');
          await tester.enterText(find.widgetWithText(TextField, 'Username'), 'johndoe');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'john@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.enterText(find.widgetWithText(TextField, 'Date of Birth (YYYY-MM-DD)'), '1990-01-01');

          // Clic sur le bouton d'inscription
          await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
          await tester.pump();

          // Vérification des appels aux services
          verify(mockAuthService.signup(any)).called(1);
          verify(mockAuthService.completeSignup(any)).called(1);

          // Vérification du message de succès
          await tester.pump();
          expect(find.text('Registration completed successfully!'), findsOneWidget);

          // Vérification de la navigation
          verify(mockNavigatorObserver.didPush(any, any));
        });

    testWidgets('signup failure (email exists) shows error message with login link',
            (WidgetTester tester) async {
          // Configuration des mocks
          when(mockAuthService.signup(any)).thenAnswer((_) async => {
            'success': false,
            'message': 'Email already exists',
          });

          // Création du widget
          await tester.pumpWidget(createRegisterPage());

          // Remplissage de tous les champs
          await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'John');
          await tester.enterText(find.widgetWithText(TextField, 'Last Name'), 'Doe');
          await tester.enterText(find.widgetWithText(TextField, 'Username'), 'johndoe');
          await tester.enterText(find.widgetWithText(TextField, 'Email'), 'john@example.com');
          await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
          await tester.enterText(find.widgetWithText(TextField, 'Date of Birth (YYYY-MM-DD)'), '1990-01-01');

          // Clic sur le bouton d'inscription
          await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
          await tester.pump();

          // Vérification de l'appel au service
          verify(mockAuthService.signup(any)).called(1);

          // Vérification du message d'erreur et du lien de connexion
          await tester.pump();
          expect(find.text('Email already exists Vous pouvez essayer de vous connecter.'), findsOneWidget);
          expect(find.text('Se connecter'), findsOneWidget);
        });

    testWidgets('completeSignup failure shows error message', (WidgetTester tester) async {
      // Configuration des mocks
      when(mockAuthService.signup(any)).thenAnswer((_) async => {
        'success': true,
        'message': 'Signup successful',
        'data': {'accessToken': 'fake_token', 'refreshToken': 'fake_refresh_token'}
      });

      when(mockAuthService.completeSignup(any)).thenAnswer((_) async => {
        'success': false,
        'message': 'Profile data invalid',
      });

      // Création du widget
      await tester.pumpWidget(createRegisterPage());

      // Remplissage de tous les champs
      await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'John');
      await tester.enterText(find.widgetWithText(TextField, 'Last Name'), 'Doe');
      await tester.enterText(find.widgetWithText(TextField, 'Username'), 'johndoe');
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'john@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.enterText(find.widgetWithText(TextField, 'Date of Birth (YYYY-MM-DD)'), '1990-01-01');

      // Clic sur le bouton d'inscription
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();

      // Vérification des appels aux services
      verify(mockAuthService.signup(any)).called(1);
      verify(mockAuthService.completeSignup(any)).called(1);

      // Vérification du message d'erreur
      await tester.pump();
      expect(find.text('Profile data invalid'), findsOneWidget);
    });

    testWidgets('shows loading indicator during registration process', (WidgetTester tester) async {
      // Configuration des mocks avec un délai
      when(mockAuthService.signup(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return {
          'success': true,
          'message': 'Signup successful',
          'data': {'accessToken': 'fake_token', 'refreshToken': 'fake_refresh_token'}
        };
      });

      when(mockAuthService.completeSignup(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return {
          'success': true,
          'message': 'Registration completed successfully',
          'data': {'accessToken': 'new_token', 'refreshToken': 'new_refresh_token'}
        };
      });

      // Création du widget
      await tester.pumpWidget(createRegisterPage());

      // Remplissage de tous les champs
      await tester.enterText(find.widgetWithText(TextField, 'First Name'), 'John');
      await tester.enterText(find.widgetWithText(TextField, 'Last Name'), 'Doe');
      await tester.enterText(find.widgetWithText(TextField, 'Username'), 'johndoe');
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'john@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
      await tester.enterText(find.widgetWithText(TextField, 'Date of Birth (YYYY-MM-DD)'), '1990-01-01');

      // Clic sur le bouton d'inscription
      await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
      await tester.pump();

      // Vérification de l'indicateur de chargement
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));

      // Attente de la fin du processus
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
