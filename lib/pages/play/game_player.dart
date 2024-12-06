import 'dart:ui';
import 'package:flame_forge2d/forge2d_game.dart';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:plock_mobile/pages/play/exitbutton.dart';
import 'package:plock_mobile/pages/play/uploadbutton.dart';

import '../../models/games/game.dart' as plock;
import 'game_player_object.dart';

/// The game player.
class GamePlayer extends Forge2DGame {

  /// The game data.
  final plock.Game game;

  /// List of all the game objects.
  List<Component> components = [];

  /// is used with the editor to test the game ?
  ///
  /// If yes, specials options are activated.
  bool isTest = false;

  /// Callback to exit the game.
  ///
  /// Only use it in test mode !
  final Function? exitGame;

  /// Callback to publish the game.
  ///
  /// Only use it in test mode !
  final Function? uploadGame;

  GamePlayer({required this.game, this.isTest = false, this.exitGame, this.uploadGame});

  void exitGameCallback() {
    for (var object in components) {
      GamePlayerObject gameObject = (object as GamePlayerObject);
      gameObject.stopEvents();
    }
    exitGame!();
  }

  @override
  Future<void> onLoad() async {
    game.screenSize = size;
    game.gamePlayer = this;

    // Add button to exit the game if in test mode
    if (isTest && exitGame != null) {
      final exitButton = ExitButton(exitGame: exitGameCallback);
      add(exitButton);
    }

    // Add button to publish the game if in test mode
    if (isTest && uploadGame != null) {
      final uploadButton = UploadButton(uploadGame: uploadGame!, screenSize: size);
      add(uploadButton);
    }

    // Generate all the game objects of the game
    for (var object in game.objects) {
      Component newComponent = GamePlayerObject(gameObject: object, plockGame: game);
      components.add(newComponent);
      add(newComponent);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    game.deltaTime = dt;

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