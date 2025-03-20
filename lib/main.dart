// This is the main file of the application.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plock_mobile/pages/my_games/my_games_page.dart';
import 'package:plock_mobile/pages/my_games/my_profile_page.dart';
import 'package:plock_mobile/pages/play/play_page.dart';

/// The main function of the application.
void main() async {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  bool isScrollEnabled = true;

  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this, initialIndex: 1);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget.isScrollEnabled = !widget.isScrollEnabled;
          });
        },
        child: Icon(widget.isScrollEnabled ? Icons.lock : Icons.lock_open),
      ),
      bottomNavigationBar: TabBar(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        tabs: const <Widget>[
          Tab(icon: Icon(Icons.account_circle)),
          Tab(icon: Icon(Icons.play_arrow)),
          Tab(icon: Icon(Icons.create)),
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          const ProfilePage(),
          PlayPage(),
          const MyGamesPage(),
        ],
      ),
    );
  }
}