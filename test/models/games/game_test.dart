import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/scene.dart' as Plock;
import 'package:plock_mobile/pages/play/game_player.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_world.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';

// Stub pour GamePlayerObject (simplified)
class StubGamePlayerObject extends Component {
  GameObject gameObject;
  StubGamePlayerObject({required this.gameObject, required Game plockGame});
}

// Stub pour GamePlayer
class StubGamePlayer extends GamePlayer {
  StubGamePlayer(Game game) : super(game: game);

  @override
  void add(Component component) {
    components.add(component);
  }

  @override
  void remove(Component component) {
    components.remove(component);
  }

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
      game.scenes.add(Plock.Scene(name: 'scene1')); // Ensure there's at least one scene
      stubGamePlayer = StubGamePlayer(game);
      game.gamePlayer = stubGamePlayer;
      game.screenSize = Vector2(100, 100);
    });

    test('spawnObject() throws exception if gamePlayer is null', () {
      game.gamePlayer = null;
      expect(() => game.spawnObject('anotherObject'), throwsException);
    });

    test('spawnAsset() throws exception if asset is not found', () {
      expect(() => game.spawnAsset('nonExistingAsset', 'test'), throwsException);
    });

    test('spawnAsset() throws exception if gamePlayer is null', () {
      game.gamePlayer = null;
      game.assets.add(GameObject(id: 0, name: 'existingAsset'));
      expect(() => game.spawnAsset('existingAsset', 'test'), throwsException);
    });

    test('destroyObject() throws exception if gamePlayer is null', () {
      game.gamePlayer = null;
      expect(() => game.destroyObject(0), throwsException);
    });

    test('toJson() includes assets and uiAssets arrays', () {
      game.assets.add(GameObject(id: 0, name: 'asset1'));
      game.uiAssets.add(GameObject(id: 1, name: 'uiAsset1'));
      final jsonString = game.toJson();
      final decodedJson = jsonDecode(jsonString);
      expect(decodedJson['assets'], isNotEmpty);
      expect(decodedJson['uiAssets'], isNotEmpty);
    });

    test('toJson() includes medias array', () {
      game.medias.add(Media(id: 0, name: 'media1'));
      final jsonString = game.toJson();
      final decodedJson = jsonDecode(jsonString);
      expect(decodedJson['medias'], isNotEmpty);
    });

    test('toJson() handles empty assets, uiAssets, and medias arrays', () {
      final jsonString = game.toJson();
      final decodedJson = jsonDecode(jsonString);
      expect(decodedJson['assets'], isEmpty);
      expect(decodedJson['uiAssets'], isEmpty);
      expect(decodedJson['medias'], isEmpty);
    });




    test('jsonToGame() returns null on invalid JSON format', () async {
      final invalidJson = {'invalid': 'format'};
      final newGame = await Game.jsonToGame(name: 'Invalid Game', json: invalidJson);
      expect(newGame, isNull);
    });
  });
}