import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
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
  /// Get all the games created by the current user.
  Future<List<Game>> getMyGames() async {
    try {
      var response = await Api.getMyGames();

      if (!response['success']) {
        print("Error fetching my games: ${response['message']}");
        return [];
      }

      final gamesList = response['data']['data'];

      List<Game> myGamesWithData = <Game>[];
      for (var game in gamesList) {
        try {
          print("Loading game: ${game['title']} (${game['id']})");
          var gameData = await http.get(Uri.parse(game['gameUrl']));

          if (gameData.statusCode != 200) {
            print("Failed to load game data: HTTP ${gameData.statusCode}");
            continue;
          }

          dynamic json;
          try {
            json = jsonDecode(gameData.body);
          } catch (e) {
            print("Error parsing game data: $e");
            continue;
          }

          Game? loadedGame = await Game.jsonToGame(
              name: game['title'],
              json: json,
              lastUpdate: DateTime.parse(game['updatedAt']));

          if (loadedGame == null) {
            print("Failed to convert JSON to Game object");
            continue;
          }

          loadedGame.uuid = game['id'];
          final mediasResponse = await Api.getMedias(game['id']);

          if (mediasResponse['success'] && mediasResponse['data'] != null) {
            for (var media in mediasResponse['data']) {
              final int index = loadedGame.medias
                  .indexWhere((element) => element.uuid == media['id']);
              if (index != -1) {
                final fileRes = await http.get(Uri.parse(media['filename']));
                final file = XFile.fromData(fileRes.bodyBytes);
                loadedGame.medias[index].file = file;
              }
            }
          }

          myGamesWithData.add(loadedGame);
        } catch (e) {
          print("Error processing game: $e");
        }
      }

      return myGamesWithData;
    } catch (e) {
      print("Exception in getMyGames: $e");
      return [];
    }
  }

  Future<List<Game>> futureProjects = Future.value([]);
  var projects = <Game>[];

  @override
  void initState() {
    super.initState();
    futureProjects = getMyGames();
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
      Api.deleteGame(game.uuid);
      projects.remove(game);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My projects'),
          backgroundColor: Colors.grey[800],
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<List<Game>>(
          future: futureProjects,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
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
                                  settings:
                                      const RouteSettings(name: '/editor'),
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
              return const Center(child: Text('No games found'));
            }
          },
        )),
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
          title: const Text('New game'),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
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
              child: const Text('Create'),
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
          title: const Text('Delete game ?'),
          content: Text('Do you really want to delete $name ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                removeProject(game);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
