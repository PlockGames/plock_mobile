import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_page.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_painter.dart';

import '../../utils/Vector2.dart';
import 'loaded_media_tile.dart';
import 'tile.dart';
import 'tilemap.dart';
import 'tilemap_editor_controller.dart';

class TilemapEditor extends StatefulWidget {
  final List<Tile> tiles;
  final List<LoadedMedia?> loadedMedias;
  final int selectedTile;
  final Tilemap tilemap;
  final int tileSize = 32;
  final Function setPos;
  final TilemapEditorController controller;

  TilemapEditor({required this.tiles, this.selectedTile = 0, required this.tilemap, required this.loadedMedias, required this.controller, required this.setPos});

  @override
  _TilemapEditorState createState() => _TilemapEditorState();
}

class _TilemapEditorState extends State<TilemapEditor> {


  Vector2 expandMap(int x, int y) {
    ExpandDirection directionHorizontal = x >= widget.tilemap.width ? ExpandDirection.left : ExpandDirection.right;
    ExpandDirection directionVertical = y >= widget.tilemap.height ? ExpandDirection.top : ExpandDirection.bottom;
    int width = widget.tilemap.width;
    int height = widget.tilemap.height;

    if (x >= widget.tilemap.width) {
      width = x + 1;
    }
    if (y >= widget.tilemap.height) {
      height = y + 1;
    }
    if (x < 0) {
      width = widget.tilemap.width - x;
    }
    if (y < 0) {
      height = widget.tilemap.height - y;
    }
    return widget.tilemap.changeSize(width, height, directionHorizontal, directionVertical);
  }

  @override
  Widget build(BuildContext context) {

    int count = 0;
    List<LoadedMediaTile> loadedMediasTiles = List<LoadedMediaTile>.empty(growable: true);

    for (int i = 0; i < widget.loadedMedias.length; i++) {
      if (widget.loadedMedias[i] != null) {
        count += widget.loadedMedias[i]!.count;

        for (int j = 0; j < widget.loadedMedias[i]!.count; j++) {
          loadedMediasTiles.add(LoadedMediaTile(loadedMedia: widget.loadedMedias[i], index: j));
        }

      } else {
        count += 1;
      }
    }


    GestureDetector buildGestureDetector(RepaintBoundary boundary) {

      return GestureDetector(
        child: boundary,
        onPanUpdate: (details) {
          if (widget.selectedTile == -2) {
            setState(() {
              int x = details.delta.dx.toInt();
              int y = details.delta.dy.toInt();
              widget.controller.x += x;
              widget.controller.y += y;

              if (widget.controller.x < widget.tilemap.width * widget.tileSize - Tilemap.MAX_WIDTH * widget.tileSize) {
                widget.controller.x = widget.tilemap.width * widget.tileSize - Tilemap.MAX_WIDTH * widget.tileSize;
              }

              if (widget.controller.y < widget.tilemap.height * widget.tileSize - Tilemap.MAX_HEIGHT * widget.tileSize) {
                widget.controller.y = widget.tilemap.height * widget.tileSize - Tilemap.MAX_HEIGHT * widget.tileSize;
              }

              if (widget.controller.x > Tilemap.MAX_WIDTH * widget.tileSize) {
                widget.controller.x = Tilemap.MAX_WIDTH * widget.tileSize;
              }

              if (widget.controller.y > Tilemap.MAX_HEIGHT * widget.tileSize) {
                widget.controller.y = Tilemap.MAX_HEIGHT * widget.tileSize;
              }

            });
          } else {
            setState(() {
              int x = ((details.localPosition.dx ~/ widget.tileSize) - (widget.controller.x / widget.tileSize)).toInt();
              int y = (details.localPosition.dy ~/ widget.tileSize) - (widget.controller.y / widget.tileSize).toInt();
              if (x >= 0 && x < widget.tilemap.width && y >= 0 && y < widget.tilemap.height) {
                widget.tilemap.map[x][y] = widget.selectedTile;
              } else {
                int dx = widget.tilemap.width;
                int dy = widget.tilemap.height;
                expandMap(x, y);
                dx = widget.tilemap.width - dx;
                dy = widget.tilemap.height - dy;
                if (x < 0) {
                  widget.controller.x -= dx * widget.tileSize;
                  x = 0;
                }
                if (y < 0) {
                  widget.controller.y -= dy * widget.tileSize;
                  y = 0;
                }
                widget.tilemap.map[x][y] = widget.selectedTile;
              }
            });
          }
        },
        onPanEnd: (details) {
          setState(() {
              widget.setPos(widget.controller.x, widget.controller.y);
          });
        },
      );
    }

    // container of screen size
    return
        Expanded(
            child: buildGestureDetector(
              RepaintBoundary(
                child: CustomPaint(
                  painter: TilemapEditorPainter(
                    controller: widget.controller,
                    tiles: widget.tiles,
                    loadedMediasTiles: loadedMediasTiles,
                    tilemap: widget.tilemap,
                  ),
                  size: Size.infinite,
                ),
              ),
            )
        );

  }
}