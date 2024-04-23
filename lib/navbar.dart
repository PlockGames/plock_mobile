import 'package:flutter/material.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Navigation());
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              label: 'Explorer',
            ),
            NavigationDestination(
              icon: Icon(Icons.play_arrow_outlined),
              label: 'Création',
            ),
          ],
        ),
        body: <Widget>[
          Placeholder(),
          MyGamesPage(),
        ][currentPageIndex]);
  }
}
