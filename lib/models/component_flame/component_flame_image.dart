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
  final ComponentType componentType;

  /// The texture of the image.
  XFile? image;

  /// The selected tile of the image.
  Future<Rect> rect;

  /// The scale of the image.
  Vector2 initScale;


  ComponentFlameImage({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    super.position,
    super.size,
    this.image,
    required this.rect,
    required this.componentType,
    required this.initScale,
  }) {
    anchor = Anchor.center;
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    if (image != null) {
      var img = await decodeImageFromList(await image!.readAsBytes());
      var loadedRect = await rect;
      sprite = Sprite(img, srcPosition: Vector2(loadedRect.left, loadedRect.top), srcSize: Vector2(loadedRect.width, loadedRect.height));
    }
    double sizeX = sprite?.image.width.toDouble() ?? 0;
    double sizeY = sprite?.image.height.toDouble() ?? 0;
    sizeY = sizeY / sizeX;
    sizeX = 1;
    size.x = sizeX * initScale.x;
    size.y = sizeY  * initScale.y;
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
  ComponentType getComponentType() {
    return componentType;
  }

  @override
  void move(double x, double y) {

  }

  @override
  bool isFullyLoaded() {
    return isLoaded;
  }

}