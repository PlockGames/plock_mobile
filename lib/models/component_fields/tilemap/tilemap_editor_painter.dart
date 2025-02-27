

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'tile.dart';
import 'tilemap.dart';
import 'tilemap_editor_controller.dart';

class TilemapEditorPainter extends CustomPainter {
  final TilemapEditorController controller;
  final List<Tile> tiles;
  final List<ui.Image?> loadedMedias;
  final Tilemap tilemap;

  TilemapEditorPainter({
    required this.controller,
    required this.tiles,
    required this.loadedMedias,
    required this.tilemap,
  });

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    for (int i = 0; i < tilemap.height; i++) {
      for (int j = 0; j < tilemap.width; j++) {
        int tileIndex = tilemap.map[i][j];
        if (tileIndex >= 0 && tileIndex < tiles.length) {
          Tile tile = tiles[tileIndex];
          ui.Image? loadedMedia = loadedMedias[tileIndex];

          if (loadedMedia != null) {
            canvas.drawImageRect(
              loadedMedia,
              Rect.fromLTWH(0, 0, loadedMedia.width!.toDouble(), loadedMedia.height!.toDouble()),
              Rect.fromLTWH(j * controller.tileSize.toDouble(), i * controller.tileSize.toDouble(), controller.tileSize.toDouble(), controller.tileSize.toDouble()),
              Paint(),
            );
          }
        }
      }
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}