import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/games/game_object.dart';

import '../../../../models/component_types/component_rect.dart';

class ObjectComponent extends PositionComponent
    with TapCallbacks, DragCallbacks {
  final selectObject;
  final isObjectSelected;
  final updateObject;

  late GameObject _gameObject;

  List<Component> displayComponents = [];
  List<ShapeComponent> selectComponents = [];

  String name = 'Object';

  ObjectComponent({
    required this.selectObject,
    required this.isObjectSelected,
    required this.updateObject,
    GameObject? gameObject
  })
  {
    if (gameObject != null) {
      _gameObject = gameObject;
    } else {
      _gameObject = GameObject(name: name);

      ComponentRect componentRect = ComponentRect();
      componentRect.setOnUpdate(updateDisplay);
      _gameObject.components.add(componentRect);
    }
  }

  get gameObject => _gameObject;

  void removeComponent(ComponentType component) {
    _gameObject.components.remove(component);
    updateDisplay();
  }

  void addComponent(ComponentType component) {
    _gameObject.components.add(component);
    updateDisplay();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(50, 50);
    position = Vector2(_gameObject.position.x, _gameObject.position.y);
    updateDisplay();
  }

  void updateDisplay() {
    for (var component in displayComponents) {
      remove(component);
    }
    displayComponents = [];

    for (var component in _gameObject.components) {
      DisplayComponents displayComponent = component.getDisplayComponent();
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

  @override
  bool onTapUp(TapUpEvent info) {
    if (isObjectSelected(this)) {
      selectObject(null);
    } else {
      selectObject(this);
    }
    return true;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _gameObject.position.x += event.localDelta.x;
    _gameObject.position.y += event.localDelta.y;
    position.x = _gameObject.position.x;
    position.y = _gameObject.position.y;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    updateObject(this);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
  }
}
