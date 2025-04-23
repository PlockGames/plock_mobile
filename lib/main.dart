// This is the main file of the application.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/pages/play/play_page.dart';
import 'package:plock_mobile/pages/login_page.dart';
import 'package:plock_mobile/pages/register_page.dart';
import 'package:plock_mobile/services/auth_service.dart';

/// The main function of the application.
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Nécessaire pour utiliser async dans main
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plock',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home:
          const AuthWrapper(), // Point d'entrée unique qui vérifie l'authentification
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MyHomePage(),
        // Les deux routes ci-dessous pointent vers le même widget pour assurer la compatibilité
        '/game': (context) => const MyHomePage(),
      },
      // Cette fonction assure que les navigations sont correctement traitées
      navigatorObservers: [
        RouteObserver(),
      ],
      // Cette fonction de navigation permet de déboguer les problèmes de navigation
      onGenerateRoute: (settings) {
        print("Navigation vers: ${settings.name}");

        // Gestion des routes par défaut
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterPage());
          case '/home':
          case '/game':
            return MaterialPageRoute(builder: (_) => const MyHomePage());
          default:
            return MaterialPageRoute(builder: (_) => const AuthWrapper());
        }
      },
    );
  }
}

/// Widget qui vérifie l'état d'authentification et redirige vers la page appropriée
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Vérifier si l'utilisateur est authentifié avec un token valide
      final isLoggedIn = await _authService.isLoggedIn();

      setState(() {
        _isAuthenticated = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur lors de la vérification de l'authentification: $e");
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un indicateur de chargement pendant la vérification
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Chargement...'),
            ],
          ),
        ),
      );
    }

    // Rediriger vers la page appropriée en fonction de l'état d'authentification
    if (_isAuthenticated) {
      return const MyHomePage();
    } else {
      return const LoginPage();
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController controller;
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        tabs: const <Widget>[
          Tab(icon: Icon(Icons.play_arrow)),
          Tab(icon: Icon(Icons.create)),
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          PlayPage(),
          const MyGamesPage(),
        ],
      ),
    );
  }
}
