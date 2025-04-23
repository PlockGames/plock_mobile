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
  /// Get all the games of the current user with their game data.
  Future<List<Game>> getAllGamesWithData() async {
    try {
      // Usar el nuevo endpoint /game/my que ya filtra por usuario autenticado
      var lastResponse = await ApiService.getMyGames(1);
      dynamic decoded = jsonDecode(lastResponse.body);

      // Verificar si data y data['data'] existen
      if (decoded == null ||
          decoded['data'] == null ||
          decoded['data']['data'] == null) {
        print('API response format error: data or data["data"] is null');
        return [];
      }

      var allGames = decoded['data']['data'];

      // Verificar que allGames sea una lista
      if (allGames is! List) {
        print('API response format error: data["data"] is not a List');
        return [];
      }

      // Manejar paginación si hay más páginas
      final lastPage = decoded['data']['meta']?['lastPage'] ?? 1;
      for (int page = 2; page <= lastPage; page++) {
        lastResponse = await ApiService.getMyGames(page);
        decoded = jsonDecode(lastResponse.body);
        if (decoded != null &&
            decoded['data'] != null &&
            decoded['data']['data'] != null &&
            decoded['data']['data'] is List) {
          allGames.addAll(decoded['data']['data']);
        }
      }

      List<Game> allGameWithData = <Game>[];
      for (var game in allGames) {
        try {
          var gameData = await http.get(Uri.parse(game['gameUrl'] ?? ''));
          late dynamic json;
          try {
            json = jsonDecode(gameData.body);
          } catch (e) {
            print('Error decoding game JSON: $e');
            continue;
          }

          Game? loadedGame = await Game.jsonToGame(
              name: game['title'] ?? 'Untitled Game',
              json: json,
              lastUpdate:
                  DateTime.tryParse(game['updatedAt'] ?? '') ?? DateTime.now());

          if (loadedGame == null) {
            continue;
          }

          loadedGame.uuid = game['id'] ?? '';
          loadedGame.thumbnailUrl = game['thumbnailUrl'];
          loadedGame.likes = game['likes'] ?? 0;
          loadedGame.gameType = game['gameType'] ?? 'Unknown';
          loadedGame.commentsCount = game['commentsCount'] ?? 0;

          final mediasResponse = await ApiService.getMedias(loadedGame.uuid);
          final mediasJson = jsonDecode(mediasResponse.body);

          // Verificar que mediasJson['data'] no sea nulo y sea una lista antes de iterar
          if (mediasJson != null &&
              mediasJson['data'] != null &&
              mediasJson['data'] is List) {
            for (var media in mediasJson['data']) {
              final int index = loadedGame.medias
                  .indexWhere((element) => element.uuid == media['id']);
              if (index != -1) {
                final fileRes =
                    await http.get(Uri.parse(media['filename'] ?? ''));
                final file = XFile.fromData(fileRes.bodyBytes);
                loadedGame.medias[index].file = file;
              }
            }
          }

          allGameWithData.add(loadedGame);
        } catch (e) {
          print('Error processing game: $e');
          // Continue to next game if there's an error with this one
          continue;
        }
      }

      return allGameWithData;
    } catch (e) {
      print('Error in getAllGamesWithData: $e');
      return [];
    }
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
        title: const Text('My projects'),
        backgroundColor: Colors.grey[800],
      ),
      body: FutureBuilder<List<Game>>(
        future: FuturProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            projects = snapshot.data!;
            projects.sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 tarjetas por fila
                  childAspectRatio:
                      0.75, // Proporción más alta para tarjetas verticales
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return _buildGameCard(context, project);
                },
              ),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.games_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No games found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to create your first game',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showGameCreationDialog(context);
        },
        backgroundColor: Colors.grey[500],
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  /// Build a game card widget
  Widget _buildGameCard(BuildContext context, Game game) {
    // Color de fondo basado en el tipo de juego o un color predeterminado
    final cardColor = _getCardColor(game.gameType);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip
          .antiAlias, // Para que la imagen no sobrepase las esquinas redondeadas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen superior o placeholder
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: cardColor.withOpacity(0.3),
                child: game.thumbnailUrl != null &&
                        game.thumbnailUrl!.isNotEmpty &&
                        !game.thumbnailUrl!.contains('test')
                    ? Image.network(
                        game.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child:
                              Icon(Icons.image_not_supported, color: cardColor),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.games, size: 50, color: cardColor),
                      ),
              ),
              // Botones de edición y eliminación
              Positioned(
                top: 4,
                right: 4,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditorPage(game: game),
                              settings: const RouteSettings(name: '/editor'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        onPressed: () => _showGameDeletionDialog(context, game),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Contenido de la tarjeta (título, fecha, etc.)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título del juego
                  Text(
                    game.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Tipo de juego
                  Text(
                    'Type: ${game.gameType ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  // Footer con fecha y likes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Fecha de actualización
                      Text(
                        _formatDate(game.lastUpdate),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      // Stats row
                      Row(
                        children: [
                          // Comments counter
                          Row(
                            children: [
                              const Icon(
                                Icons.comment,
                                size: 14,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${game.commentsCount}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          // Likes counter
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 14,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${game.likes ?? 0}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formatea la fecha para mostrarla en el formato día/mes/año
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Devuelve un color específico según el tipo de juego
  Color _getCardColor(String? gameType) {
    if (gameType == null) return Colors.blue;

    switch (gameType.toLowerCase()) {
      case 'puzzle':
        return Colors.purple;
      case 'adventure':
        return Colors.green;
      case 'arcade':
        return Colors.orange;
      case 'action':
        return Colors.red;
      case 'strategy':
        return Colors.blue;
      case 'test':
        return Colors.grey;
      default:
        return Colors.teal;
    }
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
