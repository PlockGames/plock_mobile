import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/component_flame/component_flame_tile.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';

import '../component_fields/tilemap/tile.dart';
import '../games/media.dart';

/// A flame component used in the editor to represent a rect component.
class ComponentFlameTilemap extends BodyComponent with TapCallbacks, DragCallbacks implements ComponentFlame {

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

  /// List of all the collisions of the tilemap
  List<bool> collisions = [];

  /// List of all the bodies components of each tiles
  List<BodyComponent> bodyComponents = [];

  /// The scale of the image.
  Vector2 initScale;

  /// The size of the component
  Vector2 size;


  ComponentFlameTilemap({
    required this.onDragStartCallback,
    required this.onTapeUpCallback,
    required this.onDragCancelCallback,
    required this.onDragEndCallback,
    required this.onDragUpdateCallback,
    required this.size,
    required this.tilemap,
    required this.tiles,
    required this.componentType,
    required this.initScale,
    required this.medias,
  }) {
    fixtureDefs = [
      FixtureDef(
        PolygonShape()..setAsBoxXY(1, 1),
        restitution: 0.0,
        density: 1.0,
        friction: 0.0,
        isSensor: true,
      ),
    ];

    bodyDef = BodyDef(
      position: Vector2(0,0),
      angle: 0.0,
      type: BodyType.static,
    );
  }

  Future<void> loadSprites() async {
    for (int i = 0; i < tiles.length; i++) {
      try {
        final Media media = medias.firstWhere((element) => element.name == tiles[i].media);
        final Uint8List? image = await media.file?.readAsBytes();
        final ui.Image? img = image != null ? await decodeImageFromList(image) : null;

        for (int j = 0; j < await media.getNbTiles(); j++) {

          Rect rect = await media.getTileRect(j);

          if (img != null) {
            sprites.add(Sprite(img, srcPosition: Vector2(rect.left, rect.top), srcSize: Vector2(rect.width, rect.height)));
            collisions.add(tiles[i].collision[j]);
          } else {
            sprites.add(await Sprite.load("empty.png"));
            collisions.add(false);
          }

        }
      } catch (e) {
        sprites.add(await Sprite.load("empty.png"));
        collisions.add(false);
      }
    }
  }

  @override
  Future<void> onLoad() async {
    this.size = Vector2(tilemap.width * initScale.x, tilemap.height * initScale.y);

    await loadSprites();
    for (int i = 0; i < tilemap.map.length; i++) {
      for (int x = 0; x < tilemap.width; x++) {
        for (int y = 0; y < tilemap.height; y++) {
          final int tile = tilemap.map[i][x][y];
          if (tile < 0 || tile >= sprites.length) {
            continue;
          }

          final ComponentFlameTile spriteComponent = ComponentFlameTile(
            onDragCancelCallback: onDragCancelCallback,
            onDragEndCallback: onDragEndCallback,
            onDragStartCallback: onDragStartCallback,
            onDragUpdateCallback: onDragUpdateCallback,
            onTapeUpCallback: onTapeUpCallback,
            priority: i,
            sprite: sprites[tile],
            size: Vector2(initScale.x + 0.005, initScale.y + 0.005),
            tileX: x,
            tileY: y,
            anchor: Anchor.center,
          );

          if (collisions[tile]) {
            final BodyComponent bodyComponent = BodyComponent(
              fixtureDefs: [
                FixtureDef(PolygonShape()..setAsBoxXY((initScale.x + 0.005) / 2, (initScale.y + 0.005) / 2),
                  restitution: 0.0,
                  density: 1.0,
                  friction: 0.0,
                  userData: Vector2(x.toDouble(), y.toDouble()),
                ),
              ],
              bodyDef: BodyDef(
                position: Vector2(x * initScale.x, y * initScale.y),
                angle: 0.0,
                type: BodyType.static,
              ),
              renderBody: false,
              children: [spriteComponent],
            );

            bodyComponents.add(bodyComponent);
            bodyComponent.bodyDef!.position += Vector2(this.bodyDef!.position.x, this.bodyDef!.position.y);
            world.add(bodyComponent);
            //add(bodyComponent);
          } else {
            final BodyComponent bodyComponent = BodyComponent(
              fixtureDefs: [
                FixtureDef(PolygonShape()..setAsBoxXY(initScale.x + 0.005, initScale.y + 0.005),
                  restitution: 0.0,
                  density: 1.0,
                  friction: 0.0,
                  isSensor: true,
                  userData: Vector2(x.toDouble(), y.toDouble()),
                ),
              ],
              bodyDef: BodyDef(
                position: Vector2(x * initScale.x, y * initScale.y),
                angle: 0.0,
                type: BodyType.static,
              ),
              renderBody: false,
              children: [spriteComponent],
            );
            bodyComponents.add(bodyComponent);
            bodyComponent.bodyDef!.position += Vector2(this.bodyDef!.position.x, this.bodyDef!.position.y);
            world.add(bodyComponent);
          }

          spriteComponents.add(spriteComponent);
        }
      }
    }

    await super.onLoad();
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
  void onRemove() {
    super.onRemove();
    for (final bodyComponent in bodyComponents) {
      world.remove(bodyComponent);
    }
  }

  @override
  void move(double x, double y) {

    if (this.isLoaded) {
      this.position.x = x;
      this.position.y = y;
    } else {
      this.bodyDef!.position.x = x;
      this.bodyDef!.position.y = y;
    }

    for (final bodyComponent in bodyComponents) {
      int tileX = (bodyComponent.fixtureDefs![0].userData as Vector2).x.toInt();
      int tileY = (bodyComponent.fixtureDefs![0].userData as Vector2).y.toInt();

      bodyComponent.position.x = x + tileX * initScale.x;
      bodyComponent.position.y = y + tileY * initScale.y;
    }
  }

  @override
  bool isFullyLoaded() {
    if (!isLoaded) {
      return false;
    }

    for (final spriteComponent in spriteComponents) {
      if (!spriteComponent.isLoaded) {
        return false;
      }
    }

    return true;
  }

}