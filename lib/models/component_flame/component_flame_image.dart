import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';

/// A flame component used in the editor to represent a rect component.
class ComponentFlameImage extends SpriteComponent with TapCallbacks, DragCallbacks implements ComponentFlame {

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

  /// The texture of the image.
  XFile? image;

  /// The scale of the image.
  Vector2 initScale;


  ComponentFlameImage({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    super.position,
    super.scale,
    this.image,
    this.componentType,
    required this.initScale,
  }) {
    anchor = Anchor.center;
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    if (image != null) {
      var img = await decodeImageFromList(await image!.readAsBytes());
      sprite = Sprite(img);
    }
    scale = initScale;
  }

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

  @override
  ComponentType? getComponentType() {
    return componentType;
  }

}