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
  final Map<String, bool> favoriteStatus =
      {}; // Map to store like status by game ID
  final Map<String, String> countLike =
      {}; // Map to store like counts as strings by game ID
  bool _isLoading = true;
  List<plock.Game> _recommendedGames = [];
  String _debugMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRecommendedGames();
  }

  void _logDebug(String message) {
    print("PlayPage: $message");
    setState(() {
      _debugMessage += "\n$message";
    });
  }

  Future<void> _loadRecommendedGames() async {
    setState(() {
      _isLoading = true;
      _debugMessage = 'Loading recommended games...';
    });

    try {
      _logDebug("Fetching recommendations from API...");
      final recommendedGames = await getRecommendedGamesWithData();

      if (recommendedGames.isEmpty) {
        _logDebug("No recommended games found");
      } else {
        _logDebug("Found ${recommendedGames.length} recommended games");

        // Initialize like status for recommended games
        for (var game in recommendedGames) {
          await _initializeLikeStatus(game);
        }
      }

      setState(() {
        _recommendedGames = recommendedGames;
        _isLoading = false;
      });
    } catch (e) {
      _logDebug("Error loading recommended games: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeLikeStatus(plock.Game game) async {
    try {
      var rep = await Api.getGame(game.uuid);
      _logDebug("Game API response: ${rep['success']} - ${rep['message']}");

      if (!rep['success']) {
        _logDebug("Failed to get game data for ID: ${game.uuid}");
        return;
      }

      var jsonResponse = jsonDecode(rep['data']);
      var likes = jsonResponse['data']['likes'];
      bool isLiked = jsonResponse['data']['hasLiked'] ?? false;

      setState(() {
        favoriteStatus[game.uuid] = isLiked;
        countLike[game.uuid] = likes.toString();
      });
    } catch (e) {
      _logDebug("Error initializing like status for ${game.uuid}: $e");
    }
  }

  /// Get recommended games with their data
  Future<List<plock.Game>> getRecommendedGamesWithData() async {
    var response = await Api.getRecommendation();
    _logDebug(
        "Recommendation API response: ${response['success']} - ${response['message']}");

    if (!response['success']) {
      _logDebug("API error: ${response['message']}");
      return [];
    }

    if (response['data'] == null) {
      _logDebug("No data in response");
      return [];
    }

    try {
      // The API returns data directly, not as a JSON string that needs to be parsed
      var recommendedGames = response['data'];
      _logDebug("Processing ${recommendedGames.length} games from API");
      return await _loadGameData(recommendedGames);
    } catch (e) {
      _logDebug("Error processing recommendation data: $e");
      return [];
    }
  }

  /// Helper method to load game data from API responses
  Future<List<plock.Game>> _loadGameData(List<dynamic> gamesData) async {
    List<plock.Game> gamesWithData = <plock.Game>[];

    for (var game in gamesData) {
      try {
        _logDebug("Loading game: ${game['title']} (${game['id']})");
        _logDebug("Game URL: ${game['gameUrl']}");

        var gameData = await http.get(Uri.parse(game['gameUrl']));
        if (gameData.statusCode != 200) {
          _logDebug("Failed to fetch game data: Status ${gameData.statusCode}");
          continue;
        }

        var json;
        try {
          json = jsonDecode(gameData.body);
        } catch (e) {
          _logDebug("JSON decode error: $e");
          _logDebug(
              "Response body: ${gameData.body.substring(0, min(100, gameData.body.length))}...");
          continue;
        }

        plock.Game? loadedGame = await plock.Game.jsonToGame(
            name: game["title"],
            json: json,
            lastUpdate: DateTime.parse(game['updatedAt']));

        if (loadedGame == null) {
          _logDebug("Failed to load game ${game['title']}");
          continue;
        }

        loadedGame.uuid = game['id'];
        _logDebug("Successfully loaded game: ${loadedGame.name}");
        gamesWithData.add(loadedGame);
      } catch (e) {
        _logDebug("Error loading game: $e");
      }
    }

    return gamesWithData;
  }

  // Helper function for min value
  int min(int a, int b) {
    return a < b ? a : b;
  }

  Future<void> likeGame(String gameId) async {
    await Api.addLikeGame(gameId);
  }

  Future<void> unlikeGame(String gameId) async {
    await Api.deleteLikeGame(gameId);
  }

  Widget _buildGameView(plock.Game game) {
    bool isFavorite = favoriteStatus[game.uuid] ?? false;

    return Stack(
      children: [
        // Widget principal du jeu
        GameWidget(game: GamePlayer(game: game)),

        // Boutons flottants
        Positioned(
          bottom: 100, // Position verticale
          right: 10, // Position horizontale
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
                        int currentLikes =
                            int.parse(countLike[game.uuid] ?? '0');
                        countLike[game.uuid] = (currentLikes - 1).toString();
                      });
                    });
                  } else {
                    likeGame(game.uuid).then((_) {
                      setState(() {
                        favoriteStatus[game.uuid] = true;
                        int currentLikes =
                            int.parse(countLike[game.uuid] ?? '0');
                        countLike[game.uuid] = (currentLikes + 1).toString();
                      });
                    });
                  }
                },
              ),
              SizedBox(height: 8.0),
              Text(
                countLike[game.uuid] ?? '0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),

              SizedBox(height: 10),

              // Bouton de partage
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.blue,
                  size: 40.0,
                ),
                onPressed: () {
                  final shareLink = "$url/games/${game.uuid}";
                  Clipboard.setData(ClipboardData(text: shareLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Lien copié dans le presse-papiers !"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_recommendedGames.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No recommended games found', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadRecommendedGames,
              child: Text('Refresh'),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: SingleChildScrollView(
                child: Text(_debugMessage, style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PageView(
            scrollDirection: Axis.vertical,
            children:
                _recommendedGames.map((game) => _buildGameView(game)).toList(),
          ),
        ),
      ],
    );
  }
}
