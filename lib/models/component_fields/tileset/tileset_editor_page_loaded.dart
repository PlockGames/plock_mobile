import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';

import '../tilemap/tile.dart';
import 'tileset_editor_page.dart';
import 'tileset_editor_painter.dart';

class TilesetEditorPageLoaded extends StatefulWidget {
  final Tile tile;
  final LoadedMediaTile image;
  final Media media;
  Offset offset = Offset(0, 0);


  TilesetEditorPageLoaded({required this.tile, required this.image, required this.media});

  @override
  _TilesetEditorPageLoadedState createState() => _TilesetEditorPageLoadedState();
}

class _TilesetEditorPageLoadedState extends State<TilesetEditorPageLoaded> {
  @override
  Widget build(BuildContext context) {

    GestureDetector buildGestureDetector(RepaintBoundary boundary) {
      return GestureDetector(
        child: boundary,
        onTapUp: (details) {
          int nbTileH = 1;
          if (widget.media is MediaSet) {
            MediaSet mediaSet = widget.media as MediaSet;
            nbTileH = widget.image.image.width ~/ mediaSet.tileWidth;
          }
          int tileX = (details.localPosition.dx / 32).floor();
          int tileY = (details.localPosition.dy / 32).floor();

          int index = tileY * nbTileH + tileX;
          if (index >= widget.tile.collision.length || index < 0) {
            return;
          }
          widget.tile.collision[index] = !widget.tile.collision[index];

          setState(() {
            widget.offset = Offset(tileX * 32.0, tileY * 32.0);
          });
        },
      );
    }

    return Column(
        children: [
          Expanded(
            child: buildGestureDetector(RepaintBoundary(
              child: CustomPaint(
                painter: TilesetEditorPainter(widget.tile, widget.image, widget.media),
                // screen size
                size: Size.infinite,
              ),
            )),
          ),
        ],
    );
  }
}