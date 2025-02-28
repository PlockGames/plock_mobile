import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_page.dart';
import 'package:plock_mobile/services/api.dart';
import '../../models/games/game.dart';
import 'package:http/http.dart' as http;

/// The page that display the games created by the user
class MyGamesPage extends StatefulWidget {
  const MyGamesPage({super.key});

  @override
  State<MyGamesPage> createState() => _MyGamesPageState();
}

/// The state of the [MyGamesPage]
class _MyGamesPageState extends State<MyGamesPage> {

  /// Get all the games with their game data.
  Future<List<Game>> getAllGamesWithData() async {
    var lastResponse = await ApiService.getAllGames(1);
    dynamic decoded = jsonDecode(lastResponse.body);
    var allGames = decoded['data']['data'];

    for (int page = 2; 0 < decoded.length; page++) {
      lastResponse = await ApiService.getAllGames(page);
      decoded = jsonDecode(lastResponse.body)['data']['data'];
      allGames.addAll(decoded);
    }
    List<Game> allGameWithData = <Game>[];
    for (var game in allGames) {
      var gameData = await http.get(Uri.parse(game['gameUrl']));
      var json = jsonDecode(gameData.body);
      //print(game);
      Game? loadedGame = await Game.jsonToGame(name: game['title'], json: json, lastUpdate: DateTime.parse(game['updatedAt']));
      if (loadedGame == null) {
        continue;
      }

      loadedGame.uuid = game['id'];
      if (game["creatorId"] == dotenv.env['USER_ID']) {
        allGameWithData.add(loadedGame);
      }
    }

    return allGameWithData;
  }

  Future<List<Game>> FuturProjects = Future.value([]);
  var projects = <Game>[];

  @override
  void initState() {
    super.initState();
    FuturProjects = getAllGamesWithData();
    projects = [];
  }

  Game addProject(String name) {
    Game game = Game(name: name);
    setState(() {
      projects.add(game);
    });
    return game;
  }

  void removeProject(Game game) {
    setState(() {
      ApiService.deleteGame(game.uuid);
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
          child: FutureBuilder<List<Game>>(
            future: FuturProjects,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              } else if (snapshot.hasData) {
                projects = snapshot.data!;
                projects.sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));
                return Column(
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
                );
              } else {
                return const Center(child: Text('Aucun jeu trouvé'));
              }
            },
          )
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
