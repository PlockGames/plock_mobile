// This is the main file of the application.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/pages/play/play_page.dart';
import 'package:plock_mobile/pages/login_page.dart';
import 'package:plock_mobile/pages/register_page.dart';
import 'package:plock_mobile/services/auth_service.dart';
import 'package:plock_mobile/services/auth_guard.dart';

/// The main function of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessary to use async in main
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthGuard _authGuard = AuthGuard();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Check authentication at startup and redirect if necessary
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkInitialRoute();
    });
  }

  // Check authentication at startup and redirect accordingly
  Future<void> _checkInitialRoute() async {
    try {
      final authService = AuthService();
      final isAuthenticated = await authService.isLoggedIn();

      print('Initial auth check - isAuthenticated: $isAuthenticated');

      if (isAuthenticated) {
        final token = await authService.getAccessToken();
        final isTokenValid = await _authGuard.validateToken(token);

        print('Token validation check - isTokenValid: $isTokenValid');

        if (isTokenValid) {
          print('User authenticated with valid token - Redirecting to home');
          _navigatorKey.currentState?.pushReplacementNamed('/home');
          return;
        }
      }

      // If not authenticated or token is invalid
      print('Not authenticated or invalid token - Redirecting to login');
      _navigatorKey.currentState?.pushReplacementNamed('/login');
    } catch (e) {
      print('Error during authentication check: $e');
      // Fallback to login in case of errors
      _navigatorKey.currentState?.pushReplacementNamed('/login');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Plock',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      initialRoute: '/', // Now using the root route as entry point
      routes: {
        '/': (context) => const SplashScreen(), // Initial loading screen
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MyHomePage(),
        '/game': (context) => const MyHomePage(),
      },
      navigatorObservers: [
        RouteObserver(),
      ],
      onGenerateRoute: (settings) {
        print("Navigating to: ${settings.name}");
        return _guardedRoute(settings);
      },
    );
  }

  // Function to apply AuthGuard on all routes
  Route<dynamic> _guardedRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '/';

    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        // For root or SplashScreen route, don't apply immediate redirection
        if (routeName == '/') {
          return const SplashScreen();
        }

        // Apply AuthGuard and handle redirections for other routes
        _authGuard.handleNavigation(routeName).then((String? redirectRoute) {
          if (redirectRoute != null && redirectRoute != routeName) {
            print("Redirecting to: $redirectRoute from: $routeName");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigatorKey.currentState?.pushReplacementNamed(redirectRoute);
            });
          }
        });

        // Return the corresponding widget for the requested route
        switch (routeName) {
          case '/login':
            return const LoginPage();
          case '/register':
            return const RegisterPage();
          case '/home':
          case '/game':
            return const MyHomePage();
          default:
            return const LoginPage();
        }
      },
    );
  }
}

// Initial loading screen displayed while authentication is being verified
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Plock',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
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
  final authGuard = AuthGuard();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    _checkAuthentication();
  }

  // Check if the user is authenticated
  Future<void> _checkAuthentication() async {
    final isLoggedIn = await authService.isLoggedIn();
    final tokenIsValid = isLoggedIn
        ? await authGuard.validateToken(await authService.getAccessToken())
        : false;

    if (!isLoggedIn || !tokenIsValid) {
      print("User not logged in or invalid token - Redirecting to login");
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      print("User logged in with valid token - Staying on the home page");
    }
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
