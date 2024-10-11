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
  bool isFavorite = false; // Track the state of the favorite icon

  @override
  void initState() {
    super.initState();
  }

  /// Get all the games with their game data.
  Future<List<plock.Game>> getAllGamesWithData() async {
    var lastResponse = await ApiService.getAllGames(1);
    List<dynamic> decoded = jsonDecode(lastResponse.body);
    var allGames = decoded;

    for (int page = 2; 0 < decoded.length; page++) {
      lastResponse = await ApiService.getAllGames(page);
      decoded = jsonDecode(lastResponse.body);
      allGames.addAll(decoded);
    }
    List<plock.Game> allGameWithData = <plock.Game>[];
    for (var game in allGames) {
      var gameData = await ApiService.getGameWithData(game['id'].toString());
      var json = jsonDecode(gameData.body);
      plock.Game loadedGame = await plock.Game.jsonToGame(json);
      allGameWithData.add(loadedGame);
    }
    return allGameWithData;
  }


  // Fonction pour liker un jeu via l'API
  Future<void> likeGame(String gameId) async {
    final response = await http.post(
      Uri.parse('http://141.94.223.12:3000/like'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'gameId': gameId}),
    );

    if (response.statusCode == 201) {
      print("Game liked successfully");
      setState(() {
        isFavorite = true; // Update the UI state to show the game is liked
      });
    } else if (response.statusCode == 400) {
      print("User already liked this game");
    } else {
      throw Exception('Failed to like the game');
    }
  }

  // Fonction pour unliker un jeu via l'API
  Future<void> unlikeGame(String gameId) async {
    final response = await http.delete(
      Uri.parse('http://141.94.223.12:3000/like/$gameId'),
    );
    if (response.statusCode == 200) {
      print("Game unliked successfully");
      setState(() {
        isFavorite = false; // Update the UI state to show the game is unliked
      });
    } else if (response.statusCode == 400) {
      print("User has not liked this game");
    } else {
      throw Exception('Failed to unlike the game');
    }
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
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!
                          .map((game) => Stack(
                        children: [
                          GameWidget(game: GamePlayer(game: game)),

                          // Positioned like button
                          Positioned(
                            bottom: 100, // Adjust this value for vertical position
                            right: 10,   // Adjust this value for horizontal position
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 40.0, // Smaller icon size
                              ),
                              onPressed: () {
                                if (isFavorite) {
                                  // If already liked, send an unlike request
                                  unlikeGame(game.id).then((_) {
                                    // Mettre à jour l'état après unlike
                                    setState(() {
                                      isFavorite = false;
                                    });
                                  });
                                } else {
                                  // If not liked, send a like request
                                  likeGame(game.id).then((_) {
                                    // Mettre à jour l'état après like
                                    setState(() {
                                      isFavorite = true;
                                    });
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          );
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}