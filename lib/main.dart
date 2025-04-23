// This is the main file of the application.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plock_mobile/pages/games/games_search_page.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/pages/play/play_page.dart';
import 'package:plock_mobile/pages/login_page.dart';
import 'package:plock_mobile/pages/register_page.dart';
import 'package:plock_mobile/pages/profile/my_profile_page.dart';
import 'package:plock_mobile/services/auth_service.dart';
import 'package:plock_mobile/services/auth_guard.dart';
import 'package:plock_mobile/theme.dart';

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
      theme: PlockTheme.darkTheme(),
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
    return Scaffold(
      backgroundColor: PlockTheme.backgroundDark,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PlockTheme.backgroundDark,
              Color(0xFF1A237E).withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo container with glow effect
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: PlockTheme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: PlockTheme.primaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.games,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App name with custom styling
              const Text(
                'PLOCK',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Tagline
              Text(
                'Create. Play. Share.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(PlockTheme.accentColor),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
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

  // For animated appbar
  bool _showTitle = true;
  int _lastTab = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this, initialIndex: 0);
    _checkAuthentication();

    // Listen for tab changes to update UI
    controller.addListener(() {
      if (controller.index != _lastTab) {
        setState(() {
          _lastTab = controller.index;
          // Hide title with animation on Play tab (index 0)
          _showTitle = controller.index != 0;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
      // Only show AppBar when not on Play tab (index 0)
      appBar: controller.index == 0
          ? null
          : AppBar(
              title: AnimatedOpacity(
                opacity: _showTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _getAppBarTitle(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions: [
                // Only show logout on profile tab
                if (controller.index == 3)
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () async {
                      _showLogoutDialog();
                    },
                  ),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: PlockTheme.backgroundLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: TabBar(
            controller: controller,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: PlockTheme.primaryColor,
                width: 3,
              ),
              insets: const EdgeInsets.symmetric(horizontal: 16),
            ),
            labelColor: PlockTheme.primaryColor,
            unselectedLabelColor: PlockTheme.textMuted,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.play_arrow),
                text: "Play",
              ),
              Tab(
                icon: Icon(Icons.search),
                text: "Discover",
              ),
              Tab(
                icon: Icon(Icons.create),
                text: "My Games",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          const PlayPage(),
          const GamesSearchPage(),
          const MyGamesPage(),
          const ProfilePage(),
        ],
      ),
    );
  }

  // Get the title based on the selected tab
  String _getAppBarTitle() {
    switch (controller.index) {
      case 0:
        return 'Play';
      case 1:
        return 'Discover Games';
      case 2:
        return 'My Games';
      case 3:
        return 'My Profile';
      default:
        return 'Plock';
    }
  }

  // Show logout confirmation dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PlockTheme.errorColor,
              ),
              child: const Text('LOGOUT'),
              onPressed: () async {
                Navigator.of(context).pop();
                await authService.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
