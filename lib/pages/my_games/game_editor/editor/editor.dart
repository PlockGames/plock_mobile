import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_types/component_ui_text.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/scene.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_callbacks.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_callbacks.dart';
import 'package:plock_mobile/pages/play/exitbutton.dart';
import '../../../../models/games/game.dart' as Plock;
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';

import 'editor_canvas.dart';
import 'editor_mode.dart';
import 'object_component.dart';
import 'object_ui_component.dart';
import 'side_bar_component.dart';

/// The game editor.
class Editor extends Forge2DGame with DragCallbacks {

  /// The currently selected object.
  ObjectComponent? selectedObject;

  /// The list of all the objects in the game.
  List<ObjectSceneComponent> objects = [];

  /// The list of all the objects in the ui canvas.
  List<ObjectUiComponent> uiObjects = [];

  /// All the callback coming from the widget editor
  final EditorCallbacks editorCallbacks;

  /// The game data.
  final Plock.Game game;

  /// The text component to display the name of the selected object.
  late TextComponent selectedObjectName;

  /// The mode of the editor.
  EditorMode mode = EditorMode.edit;

  /// The current canvas that is being edited.
  EditorCanvas canvas = EditorCanvas.scene;

  Editor({
    required this.game,
    required this.editorCallbacks,
  });

  /// Move the camera
  ///
  /// @param delta the delta to move the camera
  void moveCamera(Vector2 delta) {
    camera.viewfinder.position -= delta;
  }

  /// change the mode of the editor
  void changeMode() {
    if (mode == EditorMode.edit) {
      mode = EditorMode.move;
    } else {
      mode = EditorMode.edit;
    }
  }

  /// get the current mode of the editor
  EditorMode getMode() {
    return mode;
  }

  /// change the canvas that is being edited
  void changeCanvas() {
    if (canvas == EditorCanvas.scene) {
      canvas = EditorCanvas.ui;
      mode = EditorMode.edit;

      for (var object in objects) {
        if (world.contains(object)) {
          world.remove(object);
        }
      }

      for (var object in uiObjects) {
        if (!camera.viewport.contains(object)) {
          camera.viewport.add(object);
        }
      }

      camera.viewfinder.position = Vector2(0, 0);

    } else {
      canvas = EditorCanvas.scene;

      for (var object in uiObjects) {
        if (camera.viewport.contains(object)) {
          camera.viewport.remove(object);
        }
      }

      for (var object in objects) {
        if (!world.contains(object)) {
          world.add(object);
        }
      }
    }
  }

  /// get the current canvas that is being edited
  EditorCanvas getCanvas() {
    return canvas;
  }

  /// Select an object.
  selectObject(ObjectComponent? object) {
    selectedObject = object;
  }

  /// Return if an object is selected.
  isObjectSelected(ObjectComponent object) {
    return selectedObject == object;
  }

  /// Update an object.
  updateObject(ObjectComponent object) {
    if (object is ObjectSceneComponent) {
      editorCallbacks.updateGameObject(object.gameObject);
      object.updateDisplay();
    }
  }

  /// Update an ui object.
  updateUiObject(ObjectUiComponent object) {
    editorCallbacks.updateUIObject(object.gameObject);
    object.updateDisplay();
  }

  /// Add a game object to the game.
  ObjectComponent addGameObjectCallback() {
    final object = ObjectSceneComponent(
        id: game.objectCount,
        selectObject: selectObject,
        isObjectSelected: isObjectSelected,
        updateObject: updateObject,
        getMode: getMode,
        moveCamera: moveCamera,
        plockGame: game
    );
    if (canvas == EditorCanvas.scene) {
      world.add(object);
    }
    objects.add(object);
    game.objectCount++;
    editorCallbacks.addGameObject(object.gameObject);
    return object;
  }

  /// Add a UI object to the game.
  ObjectUiComponent addUiGameObjectCallback() {
    final gameObject = GameObject(id: game.objectCount, name: 'UI Object');
    final middle = size / 2;
    gameObject.components.add(ComponentUiText());
    gameObject.position.x = middle.x;
    gameObject.position.y = middle.y;

    final object = ObjectUiComponent(
        id: game.objectCount,
        selectObject: selectObject,
        isObjectSelected: isObjectSelected,
        updateObject: updateUiObject,
        getMode: getMode,
        moveCamera: moveCamera,
        plockGame: game,
        gameObject: gameObject,
        position: size / 2
    );

    if (canvas == EditorCanvas.ui) {
      camera.viewport.add(object);
    }
    uiObjects.add(object);
    game.objectCount++;
    editorCallbacks.addUIObject(object.gameObject);
    return object;
  }

  /// Remove a game object from the game.
  void removeGameObjectCallback(ObjectComponent object) {
    if (object is ObjectSceneComponent) {
      editorCallbacks.removeGameObject(object.gameObject);
      if (world.contains(object)) {
        world.remove(object);
      }
      objects.remove(object);
      if (selectedObject == object) {
        selectedObject = null;
      }
    }
  }

  /// Remove a UI object from the game.
  void removeUiGameObjectCallback(ObjectUiComponent object) {
    editorCallbacks.removeUIObject(object.gameObject);
    if (camera.viewport.contains(object)) {
      camera.viewport.remove(object);
    }
    uiObjects.remove(object);
    if (selectedObject == object) {
      selectedObject = null;
    }
  }

  /// Change the current scene.
  void changeSceneCallback(Scene scene) {
    game.currentSceneIndex = game.scenes.indexOf(scene);

    for (var object in objects) {
      if (world.contains(object)) {
        world.remove(object);
      }
    }

    for (var object in uiObjects) {
      if (camera.viewport.contains(object)) {
        camera.viewport.remove(object);
      }
    }

    objects = [];
    uiObjects = [];

    for (var object in game.scenes[game.currentSceneIndex].objects) {
      ObjectSceneComponent objectComponent = ObjectSceneComponent(
          id: object.id,
          selectObject: selectObject,
          isObjectSelected: isObjectSelected,
          gameObject: object,
          updateObject: updateObject,
          getMode: getMode,
          moveCamera: moveCamera,
          plockGame: game
      );
      world.add(objectComponent);
      objects.add(objectComponent);
    }

    for (var object in game.scenes[game.currentSceneIndex].uiObjects) {
      ObjectUiComponent objectComponent = ObjectUiComponent(
          id: object.id,
          selectObject: selectObject,
          isObjectSelected: isObjectSelected,
          gameObject: object,
          updateObject: updateUiObject,
          getMode: getMode,
          moveCamera: moveCamera,
          plockGame: game
      );
      uiObjects.add(objectComponent);
    }

    camera.viewfinder.position = Vector2(0, 0);
    canvas = EditorCanvas.scene;
  }

  ObjectComponent? getSelectedObject() {
    return selectedObject;
  }

  List<ObjectComponent> getObjects() {
    return objects;
  }

  List<ObjectUiComponent> getUiObjects() {
    return uiObjects;
  }

  ObjectComponent spawnAsset(GameObject gameObject, EditorCanvas canvas) {
    final gameObjectInstance = gameObject.instance();
    gameObjectInstance.id = game.objectCount;

    if (canvas == EditorCanvas.scene) {
      final object = ObjectSceneComponent(
          id: game.objectCount,
          selectObject: selectObject,
          isObjectSelected: isObjectSelected,
          updateObject: updateObject,
          getMode: getMode,
          moveCamera: moveCamera,
          gameObject: gameObjectInstance,
          plockGame: game
      );
      world.add(object);
      objects.add(object);
      game.objectCount++;
      editorCallbacks.addGameObject(object.gameObject);
      return object;
    } else {
      final object = ObjectUiComponent(
          id: game.objectCount,
          selectObject: selectObject,
          isObjectSelected: isObjectSelected,
          updateObject: updateUiObject,
          getMode: getMode,
          moveCamera: moveCamera,
          gameObject: gameObjectInstance,
          plockGame: game
      );
      camera.viewport.add(object);
      uiObjects.add(object);
      game.objectCount++;
      editorCallbacks.addUIObject(object.gameObject);
      return object;
    }

  }

  void updateAsset(GameObject gameObject) {
    for (var object in objects) {
      if (object.gameObject.type == gameObject.type) {
        if (object.gameObject.assetId == gameObject.assetId) {
          for (int i = 0; i < object.gameObject.components.length; i++) {
            object.gameObject.components.remove(object.gameObject.components[i]);
            i--;
          }
          for (var component in gameObject.components) {
            object.gameObject.components.add(component.instance());
          }
          object.updateDisplay();
        }
      }
    }
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF858585);
  }

  @override
  void onLoad() {
    super.onLoad();

    camera.viewfinder.zoom = 50;
    camera.viewfinder.position = Vector2(0, 0);

    // Create the bottom bar
    final BottomBarCallbacks bottomBarCallbacks = BottomBarCallbacks(
        selectObject: selectObject,
        openEditor: editorCallbacks.openEditor,
        addGameObject: addGameObjectCallback,
        addUIObject: addUiGameObjectCallback,
        updateObject: updateObject,
        updateUIObject: updateUiObject,
        removeGameObject: removeGameObjectCallback,
        removeUIObject: removeUiGameObjectCallback,
        getSelectedObject: getSelectedObject,
        getObjects: getObjects,
        getUiObjects: getUiObjects,
        testGame: editorCallbacks.testGame,
        goBack: editorCallbacks.goBack,
        openObjects: editorCallbacks.openObjects,
        openAssets: editorCallbacks.openAssets,
        spawnAsset: spawnAsset,
        updateAsset: updateAsset,
        openMedias: editorCallbacks.openMedias,
        changeMode: changeMode,
        getMode: getMode,
        getCanvas: getCanvas,
        changeCanvas: changeCanvas,
        openScenes: editorCallbacks.openScenes,
        changeScene: changeSceneCallback
    );

    final bottomBar = BottomBarComponent(
        screenSize: size,
        bottomBarCallbacks: bottomBarCallbacks
    );

    final sideBar = SideBarComponent(
        screenSize: size,
        bottomBarCallbacks: bottomBarCallbacks
    );

    // display the camera
    final phoneCamera = RectangleComponent(
      size: Vector2(size.x / 50, size.y / 50),
      position: Vector2(-size.x / 2 / 50, -size.y / 2 / 50),
      paint: Paint()..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.01,
      priority: 10000 - 1,
    );

    // Create the text component to display the name of the selected object
    selectedObjectName = TextComponent()
      ..text = selectedObject?.getGameObject().name ?? ''
      ..anchor = Anchor.topLeft
      ..position = Vector2(10, size.y - 90);

    //Add the components to the editor
    camera.viewport.add(bottomBar);
    camera.viewport.add(sideBar);
    camera.viewport.add(selectedObjectName);
    world.add(phoneCamera);

    // Generate the object components of the game
    game.scenes[game.currentSceneIndex].objects.forEach((element) {
      ObjectSceneComponent objectComponent = ObjectSceneComponent(
          id: game.objectCount,
          selectObject: selectObject,
          isObjectSelected: isObjectSelected,
          gameObject: element,
          updateObject: updateObject,
          getMode: getMode,
          moveCamera: moveCamera,
          plockGame: game
      );
      //add(objectComponent);
      world.add(objectComponent);
      objects.add(objectComponent);
      game.objectCount++;
    });

    game.scenes[game.currentSceneIndex].uiObjects.forEach((element) {
      ObjectUiComponent objectComponent = ObjectUiComponent(
          id: game.objectCount,
          selectObject: selectObject,
          isObjectSelected: isObjectSelected,
          gameObject: element,
          updateObject: updateUiObject,
          getMode: getMode,
          moveCamera: moveCamera,
          plockGame: game,
      );
      uiObjects.add(objectComponent);
      game.objectCount++;
    });

    // Add an exit button
    var exitButton = ExitButton(exitGame: editorCallbacks.goBack);
    camera.viewport.add(exitButton);

    // add a body to the world to avoid error
    world.createBody(BodyDef());
  }

  @override
  void update(double dt) {
    super.update(dt);
    selectedObjectName.text = selectedObject?.getGameObject().name ?? '';
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (mode == EditorMode.move) {
      moveCamera(event.localDelta / camera.viewfinder.zoom);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
  }
}
