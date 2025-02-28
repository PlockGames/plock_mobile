import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';

import '../component_fields/tilemap/tile.dart';
import '../games/media.dart';

/// A flame component used in the editor to represent a rect component.
class ComponentFlameTilemap extends PositionComponent with TapCallbacks, DragCallbacks implements ComponentFlame {

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

  /// the tiles of the tilemap
  final List<Tile> tiles;

  /// The tilemap
  final Tilemap tilemap;

  /// list of all the images of the game
  final List<Media> medias;

  /// List of all the loaded images
  List<Sprite> sprites = [];

  /// List of all the sprite components of each tiles
  List<SpriteComponent> spriteComponents = [];

  /// The scale of the image.
  Vector2 initScale;


  ComponentFlameTilemap({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    super.position,
    super.size,
    required this.tilemap,
    required this.tiles,
    required this.componentType,
    required this.initScale,
    required this.medias,
  }) {
    anchor = Anchor.center;
  }

  Future<void> loadSprites() async {
    for (int i = 0; i < tiles.length; i++) {
      try {
        final Media media = medias.firstWhere((element) => element.name == tiles[i].media);
        final Uint8List? image = await media.file?.readAsBytes();
        if (image != null) {
          final img = await decodeImageFromList(image);
          sprites.add(Sprite(img));
        } else {
          sprites.add(await Sprite.load("empty.png"));
        }
      } catch (e) {
        sprites.add(await Sprite.load("empty.png"));
      }
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    this.size = Vector2(tilemap.width * initScale.x, tilemap.height * initScale.y);

    await loadSprites();
    for (int x = 0; x < tilemap.width; x++) {
      for (int y = 0; y < tilemap.height; y++) {
        final int tile = tilemap.map[x][y];
        if (tile < 0 || tile >= sprites.length) {
          continue;
        }
        final SpriteComponent spriteComponent = SpriteComponent(
          sprite: sprites[tile],
          size: Vector2(initScale.x + 0.005, initScale.y + 0.005),
        );
        spriteComponent.position = Vector2(x * initScale.x, y * initScale.y);
        spriteComponents.add(spriteComponent);
        add(spriteComponent);
      }

    }

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

}