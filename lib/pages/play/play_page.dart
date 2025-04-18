import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/constants/game_constants.dart';
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:flutter/services.dart'; // Pour Clipboard

String? url = dotenv.env['API_URL'];

typedef GameModeCallback = void Function(bool isInGameMode);

/// The page where the games are played.
class PlayPage extends StatefulWidget {
  bool scrollEnabled = true;
  final GameModeCallback? onGameModeChanged;

  PlayPage({Key? key, this.scrollEnabled = true, this.onGameModeChanged}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayPageState();
  }
}

class PlayPageState extends State<PlayPage> {
  List<GameWidget> games = [];
  final Map<String, bool> favoriteStatus = {}; // Map to store like status by game ID
  final Map<String, String> countLike = {}; // Map to store like counts as strings by game ID

  // Map pour stocker les instances de GamePlayer
  final Map<String, GamePlayer> gamePlayerInstances = {};
  final Map<String, int> gameResetKeys = {};

  bool isGameMode = false;
  bool isPaused = false;
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  // Pour eviter le rechargement du jeu quand on rentre en game mode
  Future<List<plock.Game>> _gamesFuture = Future.value([]);
  List<plock.Game> _loadedGames = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _gamesFuture = getAllGamesWithData().then((games) {
      setState(() {
        _loadedGames = games;
      });
      return games;
    });
    _initializeFavoriteStatus();
    _isInitialized = true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Basculer entre le mode jeu et le mode défilement
  void toggleGameMode() {
    setState(() {
      // Si on sort du mode jeu, réinitialiser le jeu actuel
      if (isGameMode) {
        _resetCurrentGame();
        isPaused = false;
      }

      isGameMode = !isGameMode;

      if (widget.onGameModeChanged != null) {
        widget.onGameModeChanged!(isGameMode);
      }
    });
  }

  void _resetCurrentGame() {
    if (_loadedGames.isNotEmpty && currentPageIndex < _loadedGames.length) {
      plock.Game currentGame = _loadedGames[currentPageIndex];
      // Recréer l'instance du GamePlayer pour réinitialiser le jeu
      if (currentGame.uuid != null) {
        setState(() {
          // Incrémenter la clé de réinitialisation pour forcer une reconstruction complète
          gameResetKeys[currentGame.uuid] = (gameResetKeys[currentGame.uuid] ?? 0) + 1;
          gamePlayerInstances[currentGame.uuid] = GamePlayer(game: currentGame);
        });
      }
    }
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
      _pauseOrResumeCurrentGame();
    });
  }

  void _pauseOrResumeCurrentGame() {
    if (_loadedGames.isNotEmpty && currentPageIndex < _loadedGames.length) {
      plock.Game currentGame = _loadedGames[currentPageIndex];
      if (currentGame.uuid != null) {
        GamePlayer? gamePlayer = gamePlayerInstances[currentGame.uuid];
        if (gamePlayer != null) {
          if (isPaused) {
            gamePlayer.pauseEngine();
          } else {
            gamePlayer.resumeEngine();
          }
        }
      }
    }
  }

  Future<void> _initializeFavoriteStatus() async {
    List<plock.Game> allGames = await _gamesFuture;
    for (var game in allGames) {
      var rep = await Api.getGame(game.uuid);
      var jsonResponse = rep['data'];
      var likes = jsonResponse['likes'];

      if (mounted) {
        setState(() {
          favoriteStatus[game.uuid] = jsonResponse['hasLiked'];
          countLike[game.uuid] = likes.toString();
        });
      }
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
    return FutureBuilder<List<plock.Game>>(
      future: _gamesFuture,
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          List<plock.Game> games = snapshot.data!;
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
                            isPaused = false;
                            if (widget.onGameModeChanged != null) {
                              widget.onGameModeChanged!(false);
                            }
                          }
                        });
                      },
                      children: games.map((game) {
                        bool isFavorite = favoriteStatus[game.uuid] ?? false;

                        // Initialiser la clé de réinitialisation si nécessaire
                        if (!gameResetKeys.containsKey(game.uuid)) {
                          gameResetKeys[game.uuid] = 0;
                        }

                        // Utiliser l'instance existante ou en créer une nouvelle
                        if (!gamePlayerInstances.containsKey(game.uuid)) {
                          gamePlayerInstances[game.uuid] = GamePlayer(game: game);
                        }
                        GamePlayer gamePlayer = gamePlayerInstances[game.uuid]!;

                        return Stack(
                          key: ValueKey('game-${game.uuid}-${gameResetKeys[game.uuid]}'),
                          children: [
                            // Widget principal du jeu
                            AbsorbPointer(
                              absorbing: !isGameMode || isPaused,
                              child: isGameMode
                                  ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.black,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: GameConstants.standardResolution.x,
                                    height: GameConstants.standardResolution.y,
                                    child: GameWidget(
                                      key: ValueKey('gameWidget-${game.uuid}-${gameResetKeys[game.uuid]}'),
                                      game: gamePlayer,
                                    ),
                                  ),
                                ),
                              )
                                  : Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width * (GameConstants.standardResolution.y / GameConstants.standardResolution.x),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                                  color: Colors.black,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: GameConstants.standardResolution.x,
                                    height: GameConstants.standardResolution.y,
                                    child: GameWidget(
                                      key: ValueKey('gameWidget-${game.uuid}-${gameResetKeys[game.uuid]}'),
                                      game: gamePlayer,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            if (!isGameMode)
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: toggleGameMode, // Active le mode jeu au tap
                                  child: Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 16),
                                          Text(
                                            'Appuyez pour jouer',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10.0,
                                                  color: Colors.black,
                                                  offset: Offset(2.0, 2.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Overlay pour le mode pause
                            if (isGameMode && isPaused)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.7),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Jeu en pause',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            onPressed: togglePause,
                                            child: Text(
                                              'Reprendre',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            onPressed: () {
                                              _resetCurrentGame();
                                              togglePause(); // Reprendre le jeu après rafraîchissement
                                            },
                                            child: Text(
                                              'Rafraîchir',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

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
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              // Bouton flottant pour quitter le mode jeu
              if (isGameMode)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton de pause
                      FloatingActionButton(
                        heroTag: "pauseButton",
                        elevation: 5,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          isPaused ? Icons.play_arrow : Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: togglePause,
                      ),
                      SizedBox(height: 10),
                      // Bouton de fermeture qui réinitialise le jeu
                      FloatingActionButton(
                        heroTag: "closeButton",
                        elevation: 5,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: toggleGameMode,
                      ),
                    ],
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
