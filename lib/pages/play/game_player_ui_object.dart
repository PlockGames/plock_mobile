import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_js_plus/flutter_js.dart';
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
  JavascriptRuntime js = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false);

  /// does the gameObject need to abort the event ?
  bool needAbort = false;

  GamePlayerUiObject({
    required this.gameObject,
    required this.plockGame,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    super.position = Vector2(gameObject.position.x, gameObject.position.y);

    EventManager.registerEvents(js, plockGame, gameObject.id);
    js.onMessage("getNeedAbort", (args) => needAbort);
    handlePromises();

    // Update the components
    gameObject.isPhysicsDirty = false;
    updateDisplay();
    updateEvents();

    // init events
    js.evaluate("let collider = \"\";");
    js.evaluate("let colliderName = \"\";");

    if (gameObject.enabled) {
      // Execute the start events
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_START') {
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }

  }

  /// Update the display components.
  Future<void> updateDisplay() async {
    this.priority = gameObject.layer;

    if (!gameObject.enabled) {
      for (var component in this.children) {
        if (component is ComponentFlame) {
          remove(component);
        }
      }
    }

    List<String> alreadyDisplayed = [];

    // Update the components that are already instancied
    //print(this.children);
    for (var component in this.children) {
      component.priority = gameObject.layer;
      if (component is ComponentFlame) {
        ComponentFlame componentFlame = component as ComponentFlame;
        componentFlame.getComponentType().updateDisplayUi(component, this);
        alreadyDisplayed.add(componentFlame.getComponentType().uuid);
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
            comp.priority = gameObject.layer;
            add(comp);
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

    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_UPDATE') {
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
  }

  bool onTapUp(TapUpEvent info) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_TAP') {
          plockGame.lastTouchPosition =
              Vector2(info.localPosition.x, info.localPosition.y);
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
    return true;
  }

  void onDragStart(DragStartEvent event) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_START_DRAG') {
          double x = event.canvasPosition.x;
          double y = event.canvasPosition.y;
          plockGame.lastTouchPosition = Vector2(x, y);
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
  }

  void onDragUpdate(DragUpdateEvent event) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_DRAG') {
          double x = event.canvasStartPosition.x + event.canvasDelta.x;
          double y = event.canvasStartPosition.y + event.canvasDelta.y;
          plockGame.lastTouchPosition = Vector2(x, y);
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
  }

  void onDragEnd(DragEndEvent event) {
    if (gameObject.enabled) {
      for (var component in eventComponents) {
        if (component.fields['trigger']!.value == 'ON_END_DRAG') {
          executeEvent(component.fields['event']!.value[0], -1, "");
        }
      }
    }
  }

  void onDragCancel(DragCancelEvent event) {
  }

  /// Execute an event.
  void executeEvent(String event, int collider, String colliderName) async {
    if (!gameObject.enabled) {
      return;
    }

    // add break in while loops
    event = event.replaceAll("while (", "while (!sendMessage(\"getNeedAbort\", JSON.stringify([])) && ");

    // add collider to the event an wrap it in a function
    event =
        "collider = $collider\n"
        "colliderName = \"$colliderName\"\n"
        "async function event() {\n"
        "  $event\n"
        "}\n"
        "event();\n";

    js.evaluateAsync(event).then(
      (JsEvalResult jsResult) {
        if (jsResult.isError) {
          print("Error in event: ${jsResult.stringResult}");
        }
      },
    ).catchError((error) {
      print("Error in event: $error");
    });
  }

  Future<void> handlePromises() async {
    while (true) {
      js.executePendingJob();
      if (needAbort) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  void stopEvents() {
    needAbort = true;
  }

  @override
  void onRemove() {
    super.onRemove();
    stopEvents();
  }

}

