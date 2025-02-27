import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/games/game.dart' as Plock;
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

import '../../../../models/component_types/component_rect.dart';
import 'editor_mode.dart';

/// A flame object that represents a component in the game editor.
class ObjectUiComponent extends PositionComponent
    with TapCallbacks, DragCallbacks, ObjectComponent {

  /// The function to select an object.
  ///
  /// Passed on by the constructor.
  final Function selectObject;

  /// The function to check if an object is selected.
  ///
  /// Passed on by the constructor.
  final Function isObjectSelected;

  /// The function to update an object.
  ///
  /// Passed on by the constructor.
  final Function updateObject;

  /// The function to get the current mode of the editor.
  ///
  /// Passed on by the constructor.
  final Function getMode;

  /// The function to move the camera
  ///
  /// Passed on by the constructor.
  final Function(Vector2 delta) moveCamera;

  /// The game object linked to this Flame object.
  ///
  /// Passed on by the constructor.
  late GameObject _gameObject;

  /// List of all the components that can be displayed.
  List<Component> displayComponents = [];

  /// List of display component that are displayed when the object is selected.
  List<ShapeComponent> selectComponents = [];

  /// The game the object comes from.
  final Plock.Game plockGame;

  ObjectUiComponent({
    required id,
    required this.selectObject,
    required this.isObjectSelected,
    required this.updateObject,
    required this.getMode,
    required this.moveCamera,
    required this.plockGame,
    GameObject? gameObject,
    super.position,
  })
  {
    // If no game object is passed, create a new one
    if (gameObject != null) {
      _gameObject = gameObject;
    } else {
      _gameObject = GameObject(id: id, name: "Object");

      ComponentRect componentRect = ComponentRect();
      componentRect.setOnUpdate(updateDisplay);
      _gameObject.components.add(componentRect);
    }
  }

  GameObject get gameObject => _gameObject;
  void set gameObject(GameObject gameObject) {
    _gameObject = gameObject;
    updateDisplay();
  }

  /// Remove a [component] from the object.
  ///
  /// The [component] is removed from the object and the display is updated.
  void removeComponent(ComponentType component) {
    _gameObject.components.remove(component);
    updateDisplay();
  }

  /// Add a [component] to the object.
  ///
  /// The [component] is added to the object and the display is updated.
  void addComponent(ComponentType component) {
    _gameObject.components.add(component);
    updateDisplay();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    super.position = Vector2(_gameObject.position.x, _gameObject.position.y);
    // Update the components
    updateDisplay();
  }

  /// Update the display components.
  @override
  void updateDisplay() {
    // Empty the display component list
    for (var component in displayComponents) {
      remove(component);
    }
    displayComponents = [];

    // Fill the display component list with updated components
    for (var component in _gameObject.components) {
      DisplayComponents displayComponent = component.getDisplayComponent(
          plockGame.medias,
          onTapUpCallback,
          onDragStartCallback,
          onDragUpdateCallback,
          onDragEndCallback,
          onDragCancelCallback);
      if (displayComponent.display != null) {
        displayComponents.add(displayComponent.display!);
        add(displayComponent.display!);
      }

      if (displayComponent.select != null) {
        selectComponents.add(displayComponent.select!);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render components (and select components if object is selected)
    if (isObjectSelected(this)) {
      for (var component in selectComponents) {
        component.paint = Paint()
          ..color = Color.fromARGB(255, 223, 180, 12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
      }
    } else {
      for (var component in selectComponents) {
        component.paint = Paint()
          ..color = const Color(0x00F5D142)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  bool onTapUpCallback(TapUpEvent info) {
    if (getMode() == EditorMode.edit) {
      if (isObjectSelected(this)) {
        selectObject(null);
      } else {
        selectObject(this);
      }
      return true;
    }
    return false;
  }

  void onDragStartCallback(DragStartEvent event) {
    super.onDragStart(event);
  }

  void onDragUpdateCallback(DragUpdateEvent event) {
    super.onDragUpdate(event);

    if (getMode() == EditorMode.edit) {
      // update position if object is dragged
      _gameObject.position.x += event.localDelta.x;
      _gameObject.position.y += event.localDelta.y;
      position.x = _gameObject.position.x;
      position.y = _gameObject.position.y;
    } else if (getMode() == EditorMode.move) {
      moveCamera(event.localDelta);
    }
  }

  void onDragEndCallback(DragEndEvent event) {
    super.onDragEnd(event);

    // Update object position when drag ends
    updateObject(this);
  }

  void onDragCancelCallback(DragCancelEvent event) {
    super.onDragCancel(event);
  }

  @override
  getGameObject() {
    return _gameObject;
  }
}
