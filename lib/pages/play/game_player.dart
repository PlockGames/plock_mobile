import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';

import '../../models/games/game.dart' as plock;
import 'game_player_object.dart';

class GamePlayer extends FlameGame {
  final plock.Game game;

  GamePlayer(this.game);

  @override
  Future<void> onLoad() async {
    for (var object in game.objects) {
      add(GamePlayerObject(gameObject: object)
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

}