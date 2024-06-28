import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:plock_mobile/models/utils/Vector2i.dart';

import '../../models/games/game.dart' as plock;
import 'game_player_object.dart';

class GamePlayer extends FlameGame {
  final plock.Game game;
  List<Component> components = [];

  GamePlayer(this.game);

  @override
  Future<void> onLoad() async {
    game.screenSize = size;

    for (var object in game.objects) {
      Component newComponent = GamePlayerObject(gameObject: object, game: game);
      components.add(newComponent);
      add(newComponent);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
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