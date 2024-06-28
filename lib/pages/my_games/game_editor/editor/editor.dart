import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../../../../models/games/game.dart' as Plock;
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

/// The game editor.
class Editor extends FlameGame {

  /// The currently selected object.
  ObjectComponent? selectedObject;

  // Callback to update the game
  /// The function to open the object editor.
  final Function openEditor;
  /// The function to add a game object to the game.
  final Function addGameObject;
  /// The function to remove a game object from the game.
  final Function removeGameObject;
  /// The function to update a game object in the game.
  final Function updateGameObject;
  /// The function to upload the game.
  final Function uploadGame;

  /// The game data.
  final Plock.Game game;

  /// The text component to display the name of the selected object.
  late TextComponent selectedObjectName;

  Editor({
    required this.openEditor,
    required this.game,
    required this.addGameObject,
    required this.removeGameObject,
    required this.updateGameObject,
    required this.uploadGame,
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
    updateGameObject(object.gameObject);
    object.updateDisplay();
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF858585);
  }

  @override
  void onLoad() {
    super.onLoad();
    final objectContainer = PositionComponent();

    // Create the bottom bar
    final bottomBar = BottomBarComponent(
        screenSize: size,
        objectContainer: objectContainer,
        selectObject: selectObject,
        isObjectSelected: isObjectSelected,
        openEditor: openEditor,
        addGameObject: addGameObject,
        updateObject: updateObject,
        deleteGameObject: removeGameObject,
        uploadGame: uploadGame
    );

    // Create the text component to display the name of the selected object
    selectedObjectName = TextComponent()
      ..text = selectedObject?.gameObject.name ?? ''
      ..anchor = Anchor.topLeft
      ..position = Vector2(10, size.y - 90);

    //Add the components to the editor
    add(objectContainer);
    add(bottomBar);
    add(selectedObjectName);

    // Generate the object components of the game
    game.objects.forEach((element) {
      add(ObjectComponent(selectObject: selectObject, isObjectSelected: isObjectSelected, gameObject: element, updateObject: updateObject));
    });
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
