import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:flutter/services.dart'; // Pour Clipboard

String? url = dotenv.env['API_URL'];

/// The page where the games are played.
class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayPageState();
  }
}

class PlayPageState extends State<PlayPage> {
  List<GameWidget> games = [];
  final Map<String, bool> favoriteStatus = {}; // Map to store like status by game ID
  final Map<String, String> countLike = {}; // Map to store like counts as strings by game ID

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStatus();
  }

  Future<void> _initializeFavoriteStatus() async {
    List<plock.Game> allGames = await getAllGamesWithData();
    for (var game in allGames) {
      var rep = await ApiService.getGame(game.id);
      var jsonResponse = jsonDecode(rep.body);
      var likes = jsonResponse['data']['likes'];

      var response = await ApiService.getGameLike(game.id);
      dynamic decoded = jsonDecode(response.body);
      bool isLiked = decoded['totalLikes'] > 0;
      setState(() {
        favoriteStatus[game.id] = jsonResponse['data']['hasLiked'];
        countLike[game.id] = likes.toString();
        print("-------------------------------");
        print(rep);
        print("-------------------------------");
        print(jsonResponse['data']['hasLiked']);
        print("-------------------------------");
      });
    //  print("-------------is liked ?--------------");
   //   print(favoriteStatus);
   //c   print(game.id);
   //   print("-------------is liked ?--------------");
    }
  }


  /// Get all the games with their game data.
  Future<List<plock.Game>> getAllGamesWithData() async {
    var lastResponse = await ApiService.getAllGames(1);
    dynamic decoded = jsonDecode(lastResponse.body);
    var allGames = decoded['data']['data'];

    for (int page = 2; 0 < decoded.length; page++) {
      lastResponse = await ApiService.getAllGames(page);
      decoded = jsonDecode(lastResponse.body)['data']['data'];
      allGames.addAll(decoded);
    }
    List<plock.Game> allGameWithData = <plock.Game>[];
    for (var game in allGames) {
      var gameData = await http.get(Uri.parse(game['gameUrl']));
      var json = jsonDecode(gameData.body);
      plock.Game loadedGame = await plock.Game.jsonToGame(game['id'], json);
      allGameWithData.add(loadedGame);
    }
    return allGameWithData;
  }

  Future<void> likeGame(String gameId) async {
    await ApiService.addLikeGame(gameId);
  }

  Future<void> unlikeGame(String gameId) async {
    await ApiService.deleteGame(gameId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<plock.Game>>(
      stream: getAllGamesWithData().asStream(),
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                child: PageView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.map((game) {
                    bool isFavorite = favoriteStatus[game.id] ?? false;
                    return Stack(
                      children: [
                        // Widget principal du jeu
                        GameWidget(game: GamePlayer(game: game)),

                        // Boutons flottants
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
                                    unlikeGame(game.id).then((_) {
                                      setState(() {
                                        favoriteStatus[game.id] = false;
                                      });
                                    });
                                  } else {
                                    likeGame(game.id).then((_) {
                                      setState(() {
                                        favoriteStatus[game.id] = true;
                                      });
                                    });
                                  }
                                },
                              ),

                              // Espacement entre les boutons
                              SizedBox(height: 10),

                              // Bouton de partage
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.blue, // Couleur de l'icône
                                  size: 40.0,
                                ),
                                onPressed: () {
                                  // Générer le lien de partage
                                  final shareLink = "$url/games/${game.id}";

                                  // Copier dans le presse-papiers
                                  Clipboard.setData(ClipboardData(text: shareLink));

                                  // Afficher une notification ou un message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Lien copié dans le presse-papiers !"),
                                    ),
                                  );

                                  print("Lien copié : $shareLink");
                                },
                              ),
                              SizedBox(width: 10), // Espacement entre les boutons

                              // Bouton "cœur"
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                  size: 40.0,
                                ),
                                onPressed: () {
                                  if (isFavorite) {
                                    unlikeGame(game.id).then((_) {
                                      setState(() {
                                        favoriteStatus[game.id] = false;
                                        int currentLikes = int.parse(countLike[game.id] ?? '0'); // Récupérer et convertir les likes en int
                                        countLike[game.id] = (currentLikes - 1).toString(); // Décrémenter et convertir en string
                                      });
                                    });
                                  } else {
                                    likeGame(game.id).then((_) {
                                      setState(() {
                                        favoriteStatus[game.id] = true;
                                        int currentLikes = int.parse(countLike[game.id] ?? '0'); // Récupérer et convertir les likes en int
                                        countLike[game.id] = (currentLikes + 1).toString(); // Incrémenter et convertir en string
                                      });
                                    });
                                  }
                                },
                              ),
                              SizedBox(height: 8.0), // Space between button and text
                              Text(
                                countLike[game.id] ?? '0', // Fournir '0' si countLike[game.id] est null
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


