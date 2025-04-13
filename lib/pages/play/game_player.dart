import 'package:flame/camera.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/pages/play/exitbutton.dart';
import 'package:plock_mobile/pages/play/uploadbutton.dart';

import '../../models/games/game.dart' as plock;
import 'game_player_object.dart';
import 'game_player_ui_object.dart';

/// The game player.
class GamePlayer extends Forge2DGame {

  /// The game data.
  final plock.Game game;

  /// List of all the game objects.
  List<Component> components = [];

  /// List of all the ui objects.
  List<Component> uiComponents = [];

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

  /// Set to true when all components are loaded. to start the game.
  bool isAllObjectsLoaded = false;

  /// The loading screen component
  Component? loadingScreen;

  /// do the game need to abort the events ?
  bool needAbort = false;

  GamePlayer({required this.game, this.isTest = false, this.exitGame, this.uploadGame});

  void exitGameCallback() {
    for (var object in components) {
      GamePlayerObject gameObject = (object as GamePlayerObject);
      gameObject.stopEvents();
    }
    needAbort = true;
    exitGame!();
  }

  @override
  Future<void> onLoad() async {
    game.screenSize = size;
    game.gamePlayer = this;

    camera.viewfinder.zoom = 50;
    camera.viewfinder.position = Vector2(0, 0);
    camera.viewport = MaxViewport();

    // Add button to exit the game if in test mode
    if (isTest && exitGame != null) {
      final exitButton = ExitButton(exitGame: exitGameCallback);
      camera.viewport.add(exitButton);
    }

    // Add button to publish the game if in test mode
    if (isTest && uploadGame != null) {
      final uploadButton = UploadButton(uploadGame: uploadGame!, screenSize: size);
      camera.viewport.add(uploadButton);
    }

    // Generate all the game objects of the game
    for (var object in game.scenes[game.currentSceneIndex].objects) {
      Component newComponent = GamePlayerObject(gameObject: object, plockGame: game);

      components.add(newComponent);
    }

    for (var object in game.scenes[game.currentSceneIndex].uiObjects) {
      Component newComponent = GamePlayerUiObject(gameObject: object, plockGame: game);
      uiComponents.add(newComponent);
    }

    addObjectsToWorld();

    // set parenting for all the ui objects
    for (var comp in uiComponents) {
      GamePlayerUiObject object = comp as GamePlayerUiObject;

      if (object.gameObject.parent == null) {
        camera.viewport.add(comp);
        continue;
      }

      GamePlayerUiObject? parent;
      try {
        parent = uiComponents.firstWhere((element) => (element as GamePlayerUiObject).gameObject.id == object.gameObject.parent!.id) as GamePlayerUiObject;
      } catch (e) {
        parent = null;
      }
      if (parent != null) {
        parent.add(comp);
      }
    }

    // Add the loading screen
    loadingScreen = TextComponent(
      text: "Loading...",
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
        ),
      ),
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
    );
    add(loadingScreen!);

  }

  void addObjectsToWorld() {
    // set parenting for all the objects
    for (var comp in components) {
      GamePlayerObject object = comp as GamePlayerObject;

      if (object.gameObject.parent == null) {
        //add(comp);
        world.add(comp);
        continue;
      }

      GamePlayerObject? parent;
      try {
        parent = components.firstWhere((element) => (element as GamePlayerObject).gameObject.id == object.gameObject.parent!.id) as GamePlayerObject;
      } catch (e) {
        parent = null;
      }
      if (parent != null) {
        parent.add(comp);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isAllObjectsLoaded) {
      world.gravity = Vector2(0, 0);

      for (var object in components) {
        GamePlayerObject gameObject = (object as GamePlayerObject);
        if (!gameObject.isLoaded || !gameObject.isAllComponentsLoaded) {
          return;
        }

      }

      remove(loadingScreen!);
      isAllObjectsLoaded = true;
      world.gravity = Vector2(0, 10);
    } else {

      game.deltaTime = dt;

      // If game is dirty, update all the components and objects
      if (game.isDirty) {
        game.isDirty = false;

        // Update all the components
        for (int i = 0; i < components.length; i++) {
          GamePlayerObject object = components[i] as GamePlayerObject;

          if (!game.scenes[game.currentSceneIndex].objects.contains(
              object.gameObject)) {
            components.remove(object);
            world.remove(object);
            i--;
          } else {
            object.updateDisplay();
            object.updatePhysic();
            object.updateEvents();
            object.updateObjectData();
          }
        }

        // Update all the ui components
        for (int i = 0; i < uiComponents.length; i++) {
          GamePlayerUiObject object = uiComponents[i] as GamePlayerUiObject;

          if (!game.scenes[game.currentSceneIndex].uiObjects.contains(
              object.gameObject)) {
            uiComponents.remove(object);
            camera.viewport.remove(object);
            i--;
          } else {
            object.updateDisplay();
            object.updateEvents();
          }
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void onDetach() {
    super.onDetach();
    needAbort = true;
    for (var object in components) {
      if (object is GamePlayerObject) {
        object.stopEvents();
      }
    }
    for (var object in uiComponents) {
      if (object is GamePlayerUiObject) {
        object.stopEvents();
      }
    }
  }

}