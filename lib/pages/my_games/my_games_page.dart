import 'package:flutter/material.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_page.dart';
import '../../models/games/game.dart';

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
  var projects = <Game>[];

  Game addProject(String name) {
    Game game = Game(name: name);
    setState(() {
      projects.add(game);
    });
    return game;
  }

  void removeProject(Game game) {
    setState(() {
      projects.remove(game);
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
                      Text(project.name),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditorPage(
                                game: project,
                                onGameObjectUpdated: (updatedGameObject) {},
                              ),
                              settings: const RouteSettings(name: '/editor'),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showGameDeletionDialog(context, project);
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
        ));
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
                Game game = addProject(name);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditorPage(
                      game: game,
                      onGameObjectUpdated: (updatedGameObject) {},
                    ),
                    settings: const RouteSettings(name: '/editor'),
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

  /// Show a dialog to delete a game
  void _showGameDeletionDialog(context, Game game) {
    showDialog(
      context: context,
      builder: (_) {
        String name = game.name;
        return AlertDialog(
          title: const Text('Supprimer le jeu ?'),
          content: Text('Voulez-vous vraiment supprimer le jeu $name ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                removeProject(game);
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
