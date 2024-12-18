import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_callbacks.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_callbacks.dart';
import 'package:plock_mobile/pages/play/exitbutton.dart';
import '../../../../models/games/game.dart' as Plock;
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

/// The game editor.
class Editor extends Forge2DGame {

  /// The currently selected object.
  ObjectComponent? selectedObject;

  /// All the callback coming from the widget editor
  final EditorCallbacks editorCallbacks;

  /// The game data.
  final Plock.Game game;

  /// The text component to display the name of the selected object.
  late TextComponent selectedObjectName;

  Editor({
    required this.game,
    required this.editorCallbacks,

  });

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
    editorCallbacks.updateGameObject(object.gameObject);
    object.updateDisplay();
  }

  /// Add a game object to the game.
  ObjectComponent addGameObjectCallback() {
    final object = ObjectComponent(id: game.objectCount, selectObject: selectObject, isObjectSelected: isObjectSelected, updateObject: updateObject);
    //add(object);
    world.add(object);
    game.objectCount++;
    editorCallbacks.addGameObject(object.gameObject);
    return object;
  }

  void removeGameObjectCallback(ObjectComponent object) {
    editorCallbacks.removeGameObject(object.gameObject);
    world.remove(object);
    //remove(object);
  }

  ObjectComponent? getSelectedObject() {
    return selectedObject;
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
        updateObject: updateObject,
        removeGameObject: removeGameObjectCallback,
        getSelectedObject: getSelectedObject,
        testGame: editorCallbacks.testGame,
        goBack: editorCallbacks.goBack
    );

    final bottomBar = BottomBarComponent(
        screenSize: size,
        bottomBarCallbacks: bottomBarCallbacks
    );

    // Create the text component to display the name of the selected object
    selectedObjectName = TextComponent()
      ..text = selectedObject?.gameObject.name ?? ''
      ..anchor = Anchor.topLeft
      ..position = Vector2(10, size.y - 90);

    //Add the components to the editor
    add(bottomBar);
    add(selectedObjectName);

    // Generate the object components of the game
    game.objects.forEach((element) {
      ObjectComponent objectComponent = ObjectComponent(id: game.objectCount, selectObject: selectObject, isObjectSelected: isObjectSelected, gameObject: element, updateObject: updateObject);
      add(objectComponent);
      world.add(objectComponent);
      game.objectCount++;
    });

    // Add an exit button
    var exitButton = ExitButton(exitGame: editorCallbacks.goBack);
    add(exitButton);
  }

  @override
  void update(double dt) {
    super.update(dt);
    selectedObjectName.text = selectedObject?.gameObject.name ?? '';
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
