import 'package:flutter/material.dart';

class GameEditorPage extends StatelessWidget {

  const GameEditorPage({super.key, required this.game});

  final String game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Editor'),
      ),
      body: Center(
        child: Text(game),
      ),
    );
  }
}