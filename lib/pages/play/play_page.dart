import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:flutter/services.dart'; // Pour Clipboard

String? url = dotenv.env['API_URL'];

/// The page where the games are played.
class PlayPage extends StatefulWidget {
  bool scrollEnabled = true;

  PlayPage({Key? key, this.scrollEnabled = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayPageState();
  }
}

class PlayPageState extends State<PlayPage> {
  List<GameWidget> games = [];
  final Map<String, bool> favoriteStatus = {}; // Map to store like status by game ID
  final Map<String, String> countLike = {}; // Map to store like counts as strings by game ID

  bool isGameMode = false;
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Basculer entre le mode jeu et le mode défilement
  void toggleGameMode() {
    setState(() {
      isGameMode = !isGameMode;
      // Afficher un message lors du changement de mode
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isGameMode
              ? "Mode jeu activé"
              : "Mode défilement activé"),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  Future<void> _initializeFavoriteStatus() async {
    List<plock.Game> allGames = await getAllGamesWithData();
    for (var game in allGames) {
      var rep = await Api.getGame(game.uuid);
      var jsonResponse = rep['data'];
      var likes = jsonResponse['likes'];

      setState(() {
        favoriteStatus[game.uuid] = jsonResponse['hasLiked'];
        countLike[game.uuid] = likes.toString();
      });
    }
  }

  /// Get all the games with their game data.
  Future<List<plock.Game>> getAllGamesWithData() async {
    var lastResponse = await Api.getAllGames(1);
    dynamic decoded = lastResponse['data']['data'];
    var allGames = decoded;

    for (int page = 2; 0 < decoded.length; page++) {
      lastResponse = await Api.getAllGames(page);
      decoded = lastResponse['data']['data'];
      allGames.addAll(decoded);
    }
    List<plock.Game> allGameWithData = <plock.Game>[];
    for (var game in allGames) {
      var gameData = await http.get(Uri.parse(game['gameUrl']));
      var json = jsonDecode(gameData.body);
      plock.Game? loadedGame = await plock.Game.jsonToGame(name: game["title"], json: json, lastUpdate: DateTime.parse(game['updatedAt']));
      if (loadedGame == null) {
        continue;
      }

      loadedGame.uuid = game['id'];
      final mediasJson = await Api.getMedias(game['id']);

      for (var media in mediasJson['data']) {
        final int index = loadedGame.medias.indexWhere((element) => element.uuid == media['id']);
        if (index != -1) {
          final fileRes = await http.get(Uri.parse(media['filename']));
          final file = XFile.fromData(fileRes.bodyBytes);
          loadedGame.medias[index].file = file;
        }
      }

      print('Game loaded: ${loadedGame.name}');

      allGameWithData.add(loadedGame);
    }
    return allGameWithData;
  }

  Future<void> likeGame(String gameId) async {
    await Api.addLikeGame(gameId);
  }

  Future<void> unlikeGame(String gameId) async {
    await Api.deleteLikeGame(gameId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<plock.Game>>(
      stream: getAllGamesWithData().asStream(),
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      // Désactiver le défilement lorsqu'en mode jeu
                      physics: isGameMode ? const NeverScrollableScrollPhysics() : null,
                      onPageChanged: (index) {
                        setState(() {
                          currentPageIndex = index;
                          // Réinitialiser le mode jeu lors du changement de page
                          if (isGameMode) {
                            isGameMode = false;
                          }
                        });
                      },
                      children: snapshot.data!.map((game) {
                        bool isFavorite = favoriteStatus[game.uuid] ?? false;
                        return Stack(
                          children: [
                            // Widget principal du jeu
                            GameWidget(game: GamePlayer(game: game)),

                            // Boutons flottants - masqués en mode jeu
                            if (!isGameMode)
                              Positioned(
                                bottom: 100, // Position verticale
                                right: 10,   // Position horizontale
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Bouton "cœur"
                                    IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: isFavorite ? Colors.red : Colors.grey,
                                        size: 40.0,
                                      ),
                                      onPressed: () {
                                        if (isFavorite) {
                                          unlikeGame(game.uuid).then((_) {
                                            setState(() {
                                              favoriteStatus[game.uuid] = false;
                                              int currentLikes = int.parse(countLike[game.uuid] ?? '0'); // Récupérer et convertir les likes en int
                                              countLike[game.uuid] = (currentLikes - 1).toString(); // Décrémenter et convertir en string
                                            });
                                          });
                                        } else {
                                          likeGame(game.uuid).then((_) {
                                            setState(() {
                                              favoriteStatus[game.uuid] = true;
                                              int currentLikes = int.parse(countLike[game.uuid] ?? '0'); // Récupérer et convertir les likes en int
                                              countLike[game.uuid] = (currentLikes + 1).toString(); // Incrémenter et convertir en string
                                            });
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(height: 8.0), // Space between button and text
                                    Text(
                                      countLike[game.uuid] ?? '0', // Fournir '0' si countLike[game.id] est null
                                      style: TextStyle(
                                        color: Colors.white, // Ajuster la couleur du texte
                                        fontSize: 16.0,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            if (isGameMode)
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.sports_esports, color: Colors.white, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Mode Jeu',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              // Bouton flottant pour basculer le mode jeu
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  elevation: 5,
                  backgroundColor: isGameMode ? Colors.red : Colors.green,
                  child: Icon(
                    isGameMode ? Icons.close : Icons.sports_esports,
                    color: Colors.white,
                  ),
                  onPressed: toggleGameMode,
                ),
              ),
            ],
          );
        } else if (snapshot.data != null && snapshot.data!.isEmpty) {
          return Center(child: Text('No games found'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
