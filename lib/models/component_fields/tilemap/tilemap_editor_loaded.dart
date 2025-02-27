import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_painter.dart';

import '../../games/media.dart';
import 'tile.dart';
import 'tilemap.dart';
import 'tilemap_editor_controller.dart';

class TilemapEditorLoaded extends StatefulWidget {
  final List<Tile> tiles;
  final List<ui.Image?> loadedMedias;
  final int selectedTile;
  final Tilemap tilemap;
  final int tileSize = 32;

  final TilemapEditorController controller;

  TilemapEditorLoaded({required this.tiles, this.selectedTile = 0, required this.tilemap, required this.loadedMedias})
      : controller = TilemapEditorController(tileSize: 32, width: tilemap.width, height: tilemap.height);

  @override
  _TilemapEditorLoadedState createState() => _TilemapEditorLoadedState();
}

class _TilemapEditorLoadedState extends State<TilemapEditorLoaded> {



  @override
  Widget build(BuildContext context) {

    GestureDetector buildGestureDetector(RepaintBoundary boundary) {

      return GestureDetector(
        child: boundary,
        onPanStart: (details) {
          int x = (details.localPosition.dx ~/ widget.tileSize);
          int y = (details.localPosition.dy ~/ widget.tileSize);

          widget.tilemap.map[y][x] = widget.selectedTile;
        },
        onPanUpdate: (details) {
          setState(() {
            int x = (details.localPosition.dx ~/ widget.tileSize);
            int y = (details.localPosition.dy ~/ widget.tileSize);
            widget.tilemap.map[y][x] = widget.selectedTile;

          });
        },
        onPanEnd: (details) {
          setState(() {

          });
        },
      );
    }

    return Container(
          color: Colors.grey,
          width: widget.controller.width * widget.controller.tileSize.toDouble(),
          height: widget.controller.height * widget.controller.tileSize.toDouble(),
          child: buildGestureDetector(RepaintBoundary(
            child: CustomPaint(
              painter: TilemapEditorPainter(controller: widget.controller, tiles: widget.tiles, loadedMedias: widget.loadedMedias, tilemap: widget.tilemap),
            ),
          ),
          ),
        );

  }
}