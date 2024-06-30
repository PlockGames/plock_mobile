import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:plock_mobile/models/utils/Vector2i.dart';

import '../../models/games/game.dart' as plock;
import 'game_player_object.dart';

/// The game player.
class GamePlayer extends FlameGame {

  /// The game data.
  final plock.Game game;

  /// List of all the game objects.
  List<Component> components = [];

  GamePlayer(this.game);

  @override
  Future<void> onLoad() async {
    game.screenSize = size;
    game.gamePlayer = this;

    // Generate all the game objects of the game
    for (var object in game.objects) {
      Component newComponent = GamePlayerObject(gameObject: object, game: game);
      components.add(newComponent);
      add(newComponent);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // If game is dirty, update all the components and objects
    if (game.isDirty) {
      game.isDirty = false;
      for (var component in components) {
        GamePlayerObject object = component as GamePlayerObject;
        object.updateDisplay();
        object.updateEvents();
        object.updateObjectData();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

}