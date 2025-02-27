import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/event_manager.dart';

import '../../models/games/game.dart';
import '../../models/games/game_object.dart';

/// A flame object that represents a game object in te game engine.
class GamePlayerUiObject extends PositionComponent {

  /// The game object linked to this Flame object.
  late GameObject gameObject;

  /// The game data.
  final Game plockGame;

  /// List of all the components that can be displayed.
  List<Component> displayComponents = [];

  /// List of all the events components.
  List<ComponentType> eventComponents = [];

  /// js state, used to execute events.
  JavascriptRuntime js = getJavascriptRuntime();

  GamePlayerUiObject({
    required this.gameObject,
    required this.plockGame,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    super.position = Vector2(gameObject.position.x, gameObject.position.y);

    //await lua.openLibs();
    EventManager.registerEvents(js, plockGame, gameObject.id);

    // Update the components
    gameObject.isPhysicsDirty = false;
    updateDisplay();
    updateEvents();

    // init events
    js.evaluate("let collider = \"\";");

    // Execute the start events
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_START') {
        executeEvent(component.fields['event']!.value[0], -1, "");
      }
    }

  }

  /// Update the display components.
  Future<void> updateDisplay() async {
    List<String> alreadyDisplayed = [];

    // Update the components that are already instancied
    print(this.children);
    for (var component in this.children) {
      if (component is ComponentFlame) {
        ComponentFlame componentFlame = component as ComponentFlame;
        if (componentFlame.getComponentType() == null) {
          continue;
        }
        alreadyDisplayed.add(componentFlame.getComponentType()!.uuid);
      }
    }

    // Add the new components
    for (var component in gameObject.components) {
        if (!alreadyDisplayed.contains(component.uuid)) {
          Component? comp = component.getGameDisplayComponent(
            plockGame.medias,
            onTapUp,
            onDragStart,
            onDragUpdate,
            onDragEnd,
            onDragCancel);
          if (comp != null) {
            add(comp);
            ComponentFlame componentFlame = comp as ComponentFlame;
            if (componentFlame.getComponentType() == null) {
              continue;
            }
            ComponentType componentType = componentFlame.getComponentType()!;
          }
        }
    }

  }

  /// Update the event components list.
  void updateEvents() {
    eventComponents = [];
    for (var component in gameObject.components) {
      if (component.type == 'ComponentEvent') {
        eventComponents.add(component);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_UPDATE') {

        executeEvent(component.fields['event']!.value[0], -1, "");
      }
    }

  }

  bool onTapUp(TapUpEvent info) {
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_TAP') {
        plockGame.lastTouchPosition = Vector2(info.localPosition.x, info.localPosition.y);
        executeEvent(component.fields['event']!.value[0], -1, "");
      }
    }
    return true;
  }

  void onDragStart(DragStartEvent event) {
  }

  void onDragUpdate(DragUpdateEvent event) {
    for (var component in eventComponents) {
      if (component.fields['trigger']!.value == 'ON_DRAG') {
        double x = event.canvasStartPosition.x + event.canvasDelta.x;
        double y = event.canvasStartPosition.y + event.canvasDelta.y;
        plockGame.lastTouchPosition = Vector2(x, y);
        executeEvent(component.fields['event']!.value[0], -1, "");
      }
    }
  }

  void onDragEnd(DragEndEvent event) {
  }

  void onDragCancel(DragCancelEvent event) {
  }

  /// Execute an event.
  Future<void> executeEvent(String event, int collider, String colliderName) async {
    // add collider to the event
    event = "collider = ${collider}\ncolliderName = \"${colliderName}\"\n$event";

    //print(event);

    JsEvalResult res = js.evaluate(event);

    if (res.rawResult != null) {
      //print(event);
      print(res);
    }
  }

  void stopEvents() {
    try {
      //js.dispose();
    } catch (e) {
      print("Game interrupted");
    }
  }

}

