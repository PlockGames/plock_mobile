import 'package:flutter/material.dart';

import 'game_editor/game_editor_page.dart';

/// The page that display the games created by the user
class MyGamesPage extends StatefulWidget {
  const MyGamesPage({super.key});

  @override
  State<MyGamesPage> createState() => _MyGamesPageState();

}

/// The state of the [MyGamesPage]
class _MyGamesPageState extends State<MyGamesPage> {

  /// The list of the games created by the user
  /// TODO: Replace this with a real list of games
  var projects = <String>[];

  void addProject(String name) {
    setState(() {
      projects.add(name);
    });
  }

  void removeProject(name) {
    setState(() {
      projects.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mes projets'),
          backgroundColor: Colors.grey[800],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (var project in projects)
                ListTile(
                  title: Row(
                    children: [
                      Text(project),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameEditorPage(game: project),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          removeProject(project);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showGameCreationDialog(context);
          },
          backgroundColor: Colors.grey[500],
          child: const Icon(Icons.add, size: 30),
        )
    );
  }

  /// Show a dialog to create a new game, asking for the name
  void _showGameCreationDialog(context) {
    showDialog(
      context: context,
      builder: (_) {
        var nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Nouveau jeu'),
          content: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Nom'),
              ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retour'),
            ),
            TextButton(
              onPressed: () {
                var name = nameController.text;
                if (name.isEmpty) {
                  return;
                }
                addProject(name);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameEditorPage(game: name),
                  ),
                );
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }
}