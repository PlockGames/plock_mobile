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
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour utiliser async dans main
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
      initialRoute: '/login', // Démarrer par la page de connexion
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
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
    );
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

  bool isInGameMode = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    _checkAuthentication();
  }

  // Vérifier si l'utilisateur est authentifié
  Future<void> _checkAuthentication() async {
    final isLoggedIn = await authService.isLoggedIn();
    if (!isLoggedIn) {
      print("Utilisateur non connecté - Redirection vers login");
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      print("Utilisateur connecté - Reste sur la page d'accueil");
    }
  }

  void _handleGameModeChanged(bool gameMode) {
    setState(() {
      isInGameMode = gameMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plock'),
        automaticallyImplyLeading: false,
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
      // Désactive la barre de navigation quand en mode jeu
      bottomNavigationBar: isInGameMode
          ? null
          : TabBar(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        tabs: const <Widget>[
          Tab(icon: Icon(Icons.play_arrow)),
          Tab(icon: Icon(Icons.create)),
        ],
      ),
      body: TabBarView(
        controller: controller,
        // Désactive le swipe horizontal quand en mode jeu
        physics: isInGameMode
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          PlayPage(onGameModeChanged: _handleGameModeChanged),
          const MyGamesPage(),
        ],
      ),
    );
  }
}
