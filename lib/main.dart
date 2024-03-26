
import 'package:flutter/material.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_editor_page.dart';
import 'package:plock_mobile/theme.dart';

import 'models/games/game_object.dart';

void main() {
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
      theme: plockTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ObjectEditorPage(gameObject: GameObject(name: 'New Object')),
    );
  }
}
