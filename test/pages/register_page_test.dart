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
      home: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: RegisterPage(authService: mockAuthService),
      ),
      navigatorObservers: [mockNavigatorObserver],
    );
  }

  group('RegisterPage UI Tests', () {
    testWidgets('back button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      verify(mockNavigatorObserver.didPop(any, any)).called(1);
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
      await tester.enterText(find.byType(TextFormField).at(3), 'invalid-email');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email address'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(3), 'valid@email.com');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email address'), findsNothing);
    });

    testWidgets('should validate username length', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'us');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();
      expect(find.text('Username must be at least 3 characters'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(0), 'validuser');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();
      expect(find.text('Username must be at least 3 characters'), findsNothing);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      await tester.pumpWidget(createRegisterPage());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(6), '12345');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(6), '123456');
      await tester.ensureVisible(find.text('CREATE ACCOUNT'));
      await tester.tap(find.text('CREATE ACCOUNT'));
      await tester.pumpAndSettle();
      expect(find.text('Password must be at least 6 characters'), findsNothing);
    });
  });

  group('Date Picker Tests', () {
    testWidgets('should open date picker when date field is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createRegisterPage());
          await tester.pumpAndSettle();
          await tester.tap(find.byType(TextFormField).at(4));
          await tester.pumpAndSettle();
          expect(find.byType(DatePickerDialog), findsOneWidget);
        });
  });

}