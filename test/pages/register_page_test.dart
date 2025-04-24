import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plock_mobile/pages/register_page.dart';
import 'package:plock_mobile/services/auth_service.dart';
import 'package:plock_mobile/theme.dart';

import 'register_page_test.mocks.dart';

@GenerateMocks([AuthService, NavigatorObserver])
void main() {
  late MockAuthService mockAuthService;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockAuthService = MockAuthService();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  Widget createRegisterPage() {
    return MaterialApp(
      routes: {
        '/login': (context) => const Scaffold(body: Text('Login Page')),
        '/home': (context) => const Scaffold(body: Text('Home Page')),
      },
      home: MediaQuery( // Ajoutez MediaQuery pour simuler une taille d'écran
        data: const MediaQueryData(size: Size(800, 600)), // Taille d'écran typique pour le test
        child: RegisterPage(authService: mockAuthService),
      ),
      navigatorObservers: [mockNavigatorObserver],
    );
  }

  group('RegisterPage UI Tests', () {
    testWidgets('should render all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      // Vérifier que tous les champs de formulaire sont rendus
      expect(find.text('Join Plock'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Phone Number (Optional)'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('CREATE ACCOUNT'), findsOneWidget);
      expect(find.text('Already have an account? Sign In'), findsOneWidget);
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      verify(mockNavigatorObserver.didPop(any, any)).called(1);
    });


    testWidgets('Sign In button navigates to login page', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      // Si le bouton "Sign In" est dans une zone scrollable, assurez-vous qu'il est visible
      await tester.ensureVisible(find.text('Sign In'));
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });

  group('Form Validation Tests', () {
    testWidgets('should show errors when form is submitted with empty fields',
            (WidgetTester tester) async {
          await tester.pumpWidget(createRegisterPage());
          await tester.pumpAndSettle();

          await tester.ensureVisible(find.text('CREATE ACCOUNT'));
          await tester.tap(find.text('CREATE ACCOUNT'));
          await tester.pumpAndSettle();

          expect(find.text('Username is required'), findsOneWidget);
          expect(find.text('First name is required'), findsOneWidget);
          expect(find.text('Last name is required'), findsOneWidget);
          expect(find.text('Email is required'), findsOneWidget);
          expect(find.text('Date of birth is required'), findsOneWidget);
          expect(find.text('Password is required'), findsOneWidget);
        });

    testWidgets('should validate email format', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      // Remplir un email invalide
      await tester.enterText(find.byType(TextFormField).at(3), 'invalid-email');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Vérifier l'erreur de validation de l'email
      expect(find.text('Please enter a valid email address'), findsOneWidget);

      // Maintenant essayer avec un email valide
      await tester.enterText(find.byType(TextFormField).at(3), 'valid@email.com');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Ne devrait plus trouver l'erreur de validation de l'email
      expect(find.text('Please enter a valid email address'), findsNothing);
    });

    testWidgets('should validate username length', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      // Remplir un nom d'utilisateur court
      await tester.enterText(find.byType(TextFormField).at(0), 'us');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Vérifier l'erreur de validation du nom d'utilisateur
      expect(find.text('Username must be at least 3 characters'), findsOneWidget);

      // Maintenant essayer avec un nom d'utilisateur valide
      await tester.enterText(find.byType(TextFormField).at(0), 'validuser');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Ne devrait plus trouver l'erreur de validation du nom d'utilisateur
      expect(find.text('Username must be at least 3 characters'), findsNothing);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      // Remplir un mot de passe court
      await tester.enterText(find.byType(TextFormField).at(6), '12345');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Vérifier l'erreur de validation du mot de passe
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);

      // Maintenant essayer avec un mot de passe valide
      await tester.enterText(find.byType(TextFormField).at(6), '123456');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Ne devrait plus trouver l'erreur de validation du mot de passe
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });

    testWidgets('should validate date format', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      // Entrer un format de date invalide manuellement (contourner le sélecteur de date)
      await tester.enterText(find.byType(TextFormField).at(4), '01-01-2000');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Vérifier l'erreur de validation du format de la date
      expect(find.text('Use format:yyyy-MM-DD'), findsOneWidget);

      // Maintenant essayer avec un format de date valide
      await tester.enterText(find.byType(TextFormField).at(4), '2000-01-01');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();

      // Ne devrait plus trouver l'erreur de validation du format de la date
      expect(find.text('Use format:yyyy-MM-DD'), findsNothing);
    });
  });

  group('Registration Process Tests', () {
    testWidgets('successful registration should navigate to home page',
            (WidgetTester tester) async {
          await tester.pumpWidget(createRegisterPage());
          await tester.pumpAndSettle();

          // Configurer les réponses de succès
          when(mockAuthService.signup(any)).thenAnswer((_) async => {
            'success': true,
            'message': 'Registration successful'
          });
          when(mockAuthService.completeSignup(any)).thenAnswer((_) async => {
            'success': true,
            'message': 'Profile completed'
          });

          // Remplir le formulaire avec des données valides
          await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
          await tester.enterText(find.byType(TextFormField).at(1), 'Test');
          await tester.enterText(find.byType(TextFormField).at(2), 'User');
          await tester.enterText(find.byType(TextFormField).at(3), 'test@example.com');
          await tester.enterText(find.byType(TextFormField).at(4), '2000-01-01');
          await tester.enterText(find.byType(TextFormField).at(5), '1234567890');
          await tester.enterText(find.byType(TextFormField).at(6), 'password123');

          // Soumettre le formulaire
          await tester.ensureVisible(find.text('CREATE ACCOUNT'));
          await tester.tap(find.text('CREATE ACCOUNT'));
          await tester.pumpAndSettle();

          // Vérifier que signup a été appelé
          verify(mockAuthService.signup({
            'email': 'test@example.com',
            'password': 'password123',
            'username': 'testuser',
            'birthDate': '2000-01-01',
          })).called(1);

          // Vérifier que completeSignup a été appelé
          verify(mockAuthService.completeSignup({
            'firstName': 'Test',
            'lastName': 'User',
            'phoneNumber': '1234567890',
            'birthDate': '2000-01-01',
          })).called(1);

          // Vérifier la navigation vers la page d'accueil
          expect(find.text('Home Page'), findsOneWidget);
        });

    testWidgets('shows error message when signup fails',
            (WidgetTester tester) async {
          await tester.pumpWidget(createRegisterPage());
          await tester.pumpAndSettle();

          when(mockAuthService.signup(any)).thenAnswer((_) async => {
            'success': false,
            'message': 'Registration failed: Server error'
          });

          // Remplir le formulaire (au moins les champs obligatoires)
          await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
          await tester.enterText(find.byType(TextFormField).at(3), 'test@example.com');
          await tester.enterText(find.byType(TextFormField).at(4), '2000-01-01');
          await tester.enterText(find.byType(TextFormField).at(6), 'password123');
          await tester.ensureVisible(find.text('CREATE ACCOUNT'));
          await tester.tap(find.text('CREATE ACCOUNT'));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget); // Vérifier qu'une SnackBar est affichée
          expect(find.descendant(of: find.byType(SnackBar), matching: find.text('Registration failed: Server error')), findsOneWidget);
        });

    testWidgets('shows dialog when account already exists',
            (WidgetTester tester) async {
          await tester.pumpWidget(createRegisterPage());
          await tester.pumpAndSettle();

          when(mockAuthService.signup(any)).thenAnswer((_) async => {
            'success': false,
            'message': 'Email is already taken'
          });

          // Remplir le formulaire (au moins les champs obligatoires)
          await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
          await tester.enterText(find.byType(TextFormField).at(3), 'test@example.com');
          await tester.enterText(find.byType(TextFormField).at(4), '2000-01-01');
          await tester.enterText(find.byType(TextFormField).at(6), 'password123');
          await tester.ensureVisible(find.text('CREATE ACCOUNT'));
          await tester.tap(find.text('CREATE ACCOUNT'));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsOneWidget); // Vérifier qu'une AlertDialog est affichée
          expect(find.text('Account Already Exists'), findsOneWidget);
          expect(find.text('Email is already taken\nWould you like to log in instead?'), findsOneWidget);

          await tester.tap(find.text('LOG IN'));
          await tester.pumpAndSettle();

          expect(find.text('Login Page'), findsOneWidget);
        });

    testWidgets('shows error when complete signup fails',
            (WidgetTester tester) async {
          await tester.pumpWidget(createRegisterPage());
          await tester.pumpAndSettle();

          // Configurer le succès pour l'inscription mais l'échec pour la complétion de l'inscription
          when(mockAuthService.signup(any)).thenAnswer((_) async => {
            'success': true,
            'message': 'Registration successful'
          });
          when(mockAuthService.completeSignup(any)).thenAnswer((_) async => {
            'success': false,
            'message': 'Failed to complete profile'
          });

          // Remplir le formulaire avec des données valides
          await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
          await tester.enterText(find.byType(TextFormField).at(1), 'Test');
          await tester.enterText(find.byType(TextFormField).at(2), 'User');
          await tester.enterText(find.byType(TextFormField).at(3), 'test@example.com');
          await tester.enterText(find.byType(TextFormField).at(4), '2000-01-01');
          await tester.enterText(find.byType(TextFormField).at(6), 'password123');

          // Soumettre le formulaire
          await tester.ensureVisible(find.text('CREATE ACCOUNT'));
          await tester.tap(find.text('CREATE ACCOUNT'));
          await tester.pumpAndSettle();

          // Vérifier que la snackbar d'erreur est affichée
          expect(find.text('Failed to complete profile'), findsOneWidget);
        });
  });

  group('Date Picker Tests', () {
    testWidgets('should open date picker when date field is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createRegisterPage());
          await tester.pumpAndSettle();

          // Taper sur le TextFormField de la date
          await tester.tap(find.byType(TextFormField).at(4));
          await tester.pumpAndSettle();

          expect(find.byType(DatePickerDialog), findsOneWidget);
        });
  });

  group('Loading Indicator Tests', () {
    testWidgets('should show loading indicator during registration',
    (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();

      // Vérifier que l'indicateur de chargement est affiché
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('CREATE ACCOUNT'), findsNothing);

      // Attendre la fin de l'opération
      await Future.delayed(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // L'indicateur de chargement devrait avoir disparu
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('CREATE ACCOUNT'), findsOneWidget);
    });
  });
}