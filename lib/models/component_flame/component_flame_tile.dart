import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';

import '../component_fields/image/media_select.dart';
import '../games/media.dart';

/// A flame component used in the editor to represent a rect component.
class ComponentFlameTile extends SpriteComponent with TapCallbacks, DragCallbacks {

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

  /// the tile X position in the tilemap
  int tileX;
  /// the tile Y position in the tilemap
  int tileY;

  ComponentFlameTile({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    required this.tileX,
    required this.tileY,
    super.position,
    super.size,
    super.anchor,
    super.angle,
    super.autoResize,
    super.children,
    super.key,
    super.nativeAngle,
    super.paint,
    super.priority,
    super.scale,
    super.sprite,
  });

  @override
  void update(double dt) {
    super.update(dt);
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

}