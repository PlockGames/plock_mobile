import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/scene.dart' as Plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_world.dart';

// Stub pour GamePlayerObject
class StubGamePlayerObject extends Component {
  GameObject gameObject;
  StubGamePlayerObject({required this.gameObject, required Game plockGame});
}

// Stub pour GamePlayer
class StubGamePlayer extends GamePlayer {
  StubGamePlayer(Game game) : super(game: game);

  @override
  void add(Component component) {}

  @override
  void remove(Component component) {}

  @override
  List<Component> components = [];

  @override
  Forge2DWorld world = Forge2DWorld();
}

void main() {
  group('Game', () {
    late Game game;
    late StubGamePlayer stubGamePlayer;

    setUp(() {
      game = Game(name: 'Test Game');
      stubGamePlayer = StubGamePlayer(game);
      game.gamePlayer = stubGamePlayer;
    });

    test('instance() crée une copie profonde du jeu', () {
      final gameCopy = game.instance();
      expect(gameCopy.name, game.name);
      expect(gameCopy.scenes, isNot(same(game.scenes)));
      expect(gameCopy.scenes.length, game.scenes.length);
      expect(gameCopy.scenes[0].name, game.scenes[0].name);
    });


    test('toJson() convertit le jeu en une chaîne JSON', () {
      final jsonString = game.toJson();
      expect(jsonString, isA<String>());
      expect(jsonString.isNotEmpty, true);
    });

    test('jsonToGame() crée un jeu à partir d\'un objet JSON', () async {
      final jsonString = game.toJson();
      final decodedJson = jsonDecode(jsonString);
      final newGame = await Game.jsonToGame(name: 'New Game', json: decodedJson);
      expect(newGame, isA<Game>());
      expect(newGame?.name, 'New Game');
    });
  });
}