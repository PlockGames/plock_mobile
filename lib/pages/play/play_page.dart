
import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlayPageState();
  }
}

class PlayPageState extends State<PlayPage> {
  List<GameWidget> games = [];

  @override
  void initState() {
    super.initState();
  }

  Future<List<plock.Game>> getAllGamesWithData() async {
    var allGames = await ApiService.getAllGames();
    List<plock.Game> allGameWithData = <plock.Game>[];
    for (var game in jsonDecode(allGames.body)) {
      var gameData = await ApiService.getGameWithData(game['id'].toString());
      plock.Game loadedGame = await plock.Game.jsonToGame(jsonDecode(gameData.body));
      allGameWithData.add(loadedGame);

    }
    return allGameWithData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<plock.Game>>(stream: getAllGamesWithData().asStream(), builder: (context, snapshot) {
      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
        return Column(
          children: [Expanded(child: PageView(
            scrollDirection: Axis.vertical,
            children: snapshot.data!.map((game) => GameWidget(game: GamePlayer(game))).toList(),
          ))],
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}