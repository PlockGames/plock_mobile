import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStatus();
  }

  Future<void> _initializeFavoriteStatus() async {
    List<plock.Game> allGames = await getAllGamesWithData();
    for (var game in allGames) {
      var response = await ApiService.getGameLike(game.id);
      dynamic decoded = jsonDecode(response.body);
      bool isLiked = decoded['totalLikes'] > 0;
      setState(() {
        favoriteStatus[game.id] = isLiked;
      });
      print("-------------is liked ?--------------");
      print(favoriteStatus);
      print(game.id);
      print("-------------is liked ?--------------");
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
                        GameWidget(game: GamePlayer(game: game)),
                        Positioned(
                          bottom: 100, // Adjust for vertical position
                          right: 10,   // Adjust for horizontal position
                          child: IconButton(
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
          print("ooooooo");
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
