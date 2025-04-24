// This is the main file of the application.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/pages/my_games/my_profile_page.dart';
import 'package:plock_mobile/pages/play/play_page.dart';
import 'package:plock_mobile/pages/login_page.dart';
import 'package:plock_mobile/pages/register_page.dart';
import 'package:plock_mobile/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: _buildPlockTheme(),
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

  /// Construit le thème Plock selon la charte graphique
  ThemeData _buildPlockTheme() {
    // Définition des couleurs selon la charte graphique
    const primaryBlue = Color(0xFF074888);    // Bleu #074888
    const primaryOrange = Color(0xFFFA6317);  // Orange Foncé #fa6317
    const secondaryLightBlue = Color(0xFF47F8FF); // Bleu Clair #47f8ff
    const secondaryOrange = Color(0xFFFFa13a); // Orange #ffa13a
    const secondaryLightOrange = Color(0xFFFFfde2); // Orange Clair #fffde2

    // Utilisation de Google Fonts pour avoir accès à Montserrat
    // Pour Helvetica Neue, nous utilisons '.SF Pro Text' qui est très similaire
    // ou vous pouvez inclure Helvetica Neue directement dans vos assets
    final TextTheme helveticaTextTheme = GoogleFonts.montserratTextTheme().copyWith(
      displayLarge: const TextStyle(
        fontFamily: '.SF Pro Text', // Alternative à Helvetica Neue
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.white,
      ),
      displayMedium: const TextStyle(
        fontFamily: '.SF Pro Text',
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.white,
      ),
      displaySmall: const TextStyle(
        fontFamily: '.SF Pro Text',
        fontWeight: FontWeight.w600, // Semi-Bold
        fontSize: 24,
        color: Colors.white,
      ),
      headlineMedium: const TextStyle(
        fontFamily: '.SF Pro Text',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.white,
      ),
      labelLarge: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),
    );

    return ThemeData(
      // Couleurs primaires et d'accentuation
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.dark(
        primary: primaryBlue,
        secondary: primaryOrange,
        tertiary: secondaryLightBlue,
        surface: Colors.black,
        background: Colors.black,
        onBackground: Colors.white,
        onSurface: Colors.white,
        error: Colors.red,
      ),

      // Style des boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryOrange,
          side: const BorderSide(color: secondaryOrange),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Style du texte des boutons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryLightBlue,
        ),
      ),

      // Style des AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),

      // Style des TabBar (pour la barre de navigation)
      tabBarTheme: const TabBarTheme(
        labelColor: secondaryOrange,
        unselectedLabelColor: Colors.grey,
        indicatorColor: secondaryOrange,
      ),

      // Remplacer les thèmes de texte par défaut avec notre configuration personnalisée
      textTheme: helveticaTextTheme,

      // Activer Material 3
      useMaterial3: true,
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
    controller = TabController(length: 3, vsync: this, initialIndex: 0);
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
    // Récupération des couleurs du thème
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Plock',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Short games, No limit',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          Tab(icon: Icon(Icons.person)),
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
          const ProfilePage(),
        ],
      ),
    );
  }
}
