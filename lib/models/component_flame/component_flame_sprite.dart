import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';

import '../games/media.dart';

/// A flame component used in the editor to represent a rect component.
class ComponentFlameSprite extends SpriteComponent with TapCallbacks, DragCallbacks implements ComponentFlame {

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
  PlockSpriteAnimation animation;

  /// The scale of the image.
  Vector2 initScale;

  /// Current index of the animation
  int currentFrame = -1;

  /// list of all the images of the game
  List<Media> medias;

  /// The time passed since the last frame
  double timePassed = 0;


  ComponentFlameSprite({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    super.position,
    super.size,
    required this.animation,
    required this.componentType,
    required this.initScale,
    required this.medias,
  }) {
    anchor = Anchor.center;
  }

  Future<Vector2> nextImage() async {
    if (animation.images.isEmpty) {
      return Vector2(0, 0);
    }
    Vector2 size = Vector2(0, 0);
    currentFrame = ((currentFrame + 1) % animation.images.length);

    final String currentImageName = animation.images[currentFrame].name;
    try {
      final Media media = medias.firstWhere((element) => element.name == currentImageName);
      final image = await media.getLoadedImage(index: animation.images[currentFrame].index);
      if (image != null) {
        final img = await decodeImageFromList(image.data);
        sprite = Sprite(img, srcPosition: Vector2(image.bounds.left, image.bounds.top), srcSize: Vector2(image.bounds.width, image.bounds.height));
        size = Vector2(image.bounds.width, image.bounds.height);
      } else {
        sprite = await Sprite.load("empty.png");
      }
    } catch (e) {
      sprite = await Sprite.load("empty.png");
    }
    return size;
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    Vector2 imgSize = await nextImage();
    double sizeX = imgSize.x.toDouble() ?? 0;
    double sizeY = imgSize.y.toDouble() ?? 0;
    sizeY = sizeY / sizeX;
    sizeX = 1;
    size.x = sizeX * initScale.x;
    size.y = sizeY  * initScale.y;
  }

  @override
  void update(double dt) {
    super.update(dt);
    timePassed += dt;
    if (timePassed >= animation.fps) {
      timePassed = 0;
      nextImage();
    }
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