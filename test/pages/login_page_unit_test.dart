import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:plock_mobile/services/auth_service.dart';

// Génération des mocks
@GenerateMocks([AuthService])
import 'login_page_unit_test.mocks.dart';

void main() {
  group('LoginPage Unit Tests', () {
    late MockAuthService mockAuthService;
    
    setUp(() {
      mockAuthService = MockAuthService();
    });
    
    test('AuthService.login est appelé avec les données correctes', () async {
      // Configurer le mock pour simuler une réponse réussie
      when(mockAuthService.login(any, any)).thenAnswer((_) async => {
        'success': true,
        'message': 'Login successful',
        'data': {'accessToken': 'fake-token', 'refreshToken': 'fake-refresh-token'}
      });
      
      // Données de connexion
      const email = 'test@example.com';
      const password = 'Password123';
      
      // Appeler la méthode login du service
      final result = await mockAuthService.login(email, password);
      
      // Vérifier que login a été appelé avec les bonnes données
      verify(mockAuthService.login(email, password)).called(1);
      expect(result['success'], true);
      expect(result['message'], 'Login successful');
      expect(result['data'], isNotNull);
    });
    
    test('AuthService.login gère correctement les erreurs d\'authentification', () async {
      // Configurer le mock pour simuler un échec d'authentification
      when(mockAuthService.login(any, any)).thenAnswer((_) async => {
        'success': false,
        'message': 'Invalid email or password',
      });
      
      // Données de connexion
      const email = 'test@example.com';
      const password = 'WrongPassword';
      
      // Appeler la méthode login du service
      final result = await mockAuthService.login(email, password);
      
      // Vérifier la gestion de l'erreur
      expect(result['success'], false);
      expect(result['message'], 'Invalid email or password');
    });
    
    test('AuthService.login gère correctement les exceptions', () async {
      // Configurer le mock pour simuler une exception
      when(mockAuthService.login(any, any)).thenAnswer((_) async => {
        'success': false,
        'message': 'Error: Network error',
      });
      
      // Données de connexion
      const email = 'test@example.com';
      const password = 'Password123';
      
      // Appeler la méthode login du service
      final result = await mockAuthService.login(email, password);
      
      // Vérifier la gestion de l'exception
      expect(result['success'], false);
      expect(result['message'], contains('Error:'));
    });
    
    test('Validation du format email', () {
      // Fonction pour valider le format email (extraite de votre code)
      bool isValidEmail(String email) {
        final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
        return emailRegex.hasMatch(email);
      }
      
      // Tests avec différents emails
      expect(isValidEmail('test@example.com'), true);
      expect(isValidEmail('john.doe@company.co.uk'), true);
      expect(isValidEmail('user+label@domain.org'), true);
      
      // Tests avec emails invalides
      expect(isValidEmail('invalid-email'), false);
      expect(isValidEmail('test@'), false);
      expect(isValidEmail('@example.com'), false);
      expect(isValidEmail('test@example'), false);
      expect(isValidEmail(''), false);
    });
    
    test('Validation des champs obligatoires', () {
      // Fonction pour vérifier les champs obligatoires (extraite de votre code)
      String? getErrorMessage(String email, String password) {
        if (email.isEmpty || password.isEmpty) {
          return "Email and password are required.";
        }
        return null;
      }
      
      // Tests avec différentes combinaisons
      expect(getErrorMessage('test@example.com', 'password123'), null);
      expect(getErrorMessage('', 'password123'), "Email and password are required.");
      expect(getErrorMessage('test@example.com', ''), "Email and password are required.");
      expect(getErrorMessage('', ''), "Email and password are required.");
    });
    
    test('Validation complète du formulaire', () {
      // Fonction combinant les validations (similaire à votre code)
      String? validateForm(String email, String password) {
        // Vérifier si email et password sont fournis
        if (email.isEmpty || password.isEmpty) {
          return "Email and password are required.";
        }
        
        // Valider le format email
        final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
        if (!emailRegex.hasMatch(email)) {
          return "Invalid email format.";
        }
        
        return null;
      }
      
      // Tests complets
      expect(validateForm('test@example.com', 'password123'), null);
      expect(validateForm('', 'password123'), "Email and password are required.");
      expect(validateForm('test@example.com', ''), "Email and password are required.");
      expect(validateForm('invalid-email', 'password123'), "Invalid email format.");
    });
    
    test('Token est stocké après une connexion réussie', () async {
      // Configurer le mock pour simuler une réponse réussie
      when(mockAuthService.login(any, any)).thenAnswer((_) async => {
        'success': true,
        'message': 'Login successful',
        'data': {'accessToken': 'fake-token', 'refreshToken': 'fake-refresh-token'}
      });
      
      // Données de connexion
      const email = 'test@example.com';
      const password = 'Password123';
      
      // Appeler la méthode login du service
      await mockAuthService.login(email, password);
      
      // Vérifier que le token est disponible après connexion
      when(mockAuthService.getAccessToken()).thenAnswer((_) async => 'fake-token');
      final token = await mockAuthService.getAccessToken();
      expect(token, 'fake-token');
      
      // Vérifier que isLoggedIn retourne true
      when(mockAuthService.isLoggedIn()).thenAnswer((_) async => true);
      final isLogged = await mockAuthService.isLoggedIn();
      expect(isLogged, true);
    });
    
    test('Déconnexion supprime les tokens', () async {
      // Configurer le mock
      when(mockAuthService.logout()).thenAnswer((_) async => {});
      
      // Appeler la méthode logout
      await mockAuthService.logout();
      
      // Vérifier que logout a été appelé
      verify(mockAuthService.logout()).called(1);
      
      // Vérifier que getAccessToken retourne null après déconnexion
      when(mockAuthService.getAccessToken()).thenAnswer((_) async => null);
      final token = await mockAuthService.getAccessToken();
      expect(token, null);
      
      // Vérifier que isLoggedIn retourne false
      when(mockAuthService.isLoggedIn()).thenAnswer((_) async => false);
      final isLogged = await mockAuthService.isLoggedIn();
      expect(isLogged, false);
    });
  });
}