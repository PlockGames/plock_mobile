
import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/game.dart' as plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:plock_mobile/services/api.dart';

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

  @override
  void initState() {
    super.initState();
  }

  chengeScrollEnabled(bool enabled) {
    setState(() {
      widget.scrollEnabled = enabled;
    });
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
      plock.Game? loadedGame = await plock.Game.jsonToGame(name: game["title"], json: json, lastUpdate: DateTime.parse(game['updatedAt']));
      if (loadedGame == null) {
        continue;
      }

      loadedGame.uuid = game['id'];
      final mediasResponse = await ApiService.getMedias(game['id']);
      final mediasJson = jsonDecode(mediasResponse.body);

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<plock.Game>>(stream: getAllGamesWithData().asStream(), builder: (context, snapshot) {
      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
        List<Widget> games = List<Widget>.empty(growable: true);

        for (var game in snapshot.data!) {
          games.add(GameWidget(game: GamePlayer(game: game)));
        }


        return Column(
          children: [Expanded(child: PageView(
            scrollDirection: Axis.vertical,
            children: games,
            physics: widget.scrollEnabled ? PageScrollPhysics() : NeverScrollableScrollPhysics(),
          ))],
        );
      } else if (snapshot.data != null && snapshot.data!.isEmpty) {
        return Center(child: Text('No games found'));
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}