import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';

/// A flame component used in the editor to represent a rect component.
class ComponentFlameRect extends RectangleComponent with TapCallbacks, DragCallbacks implements ComponentFlame {

  /// Callback : When the user tap up on the component.
  final Function onTapeUpCallback;
  /// Callback : When the user start to drag the component.
  final Function onDragStartCallback;
  /// Callback : When the user is dragging the component.
  final Function onDragUpdateCallback;
  /// Callback : When the user stop to drag the component.
  final Function onDragEndCallback;
  /// Callback : When the drag is cancelled.
  final Function onDragCancelCallback;

  /// The linked component, only with game player
  final ComponentType? componentType;

  /// The color of the rect.
  Color color;


  ComponentFlameRect({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    required this.color,
    super.position,
    super.size,
    this.componentType
  }) {
    this.paint = Paint()..color = color;
    anchor = Anchor.center;
  }

  @override
  bool onTapUp(TapUpEvent info) {
    return onTapeUpCallback(info);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    onDragStartCallback(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    onDragUpdateCallback(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    onDragEndCallback(event);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    onDragCancelCallback(event);
  }

  @override
  ComponentType? getComponentType() {
    return componentType;
  }

}