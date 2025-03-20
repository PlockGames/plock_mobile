import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'loaded_media_tile.dart';
import 'tile.dart';
import 'tilemap.dart';
import 'tilemap_editor_controller.dart';

class TilemapEditorPainter extends CustomPainter {
  final TilemapEditorController controller;
  final List<Tile> tiles;
  final List<LoadedMediaTile> loadedMediasTiles;
  final Tilemap tilemap;

  TilemapEditorPainter({
    required this.controller,
    required this.tiles,
    required this.loadedMediasTiles,
    required this.tilemap,
  });

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.grey);

    // draw map
    for (int layer = 0; layer < tilemap.map.length; layer++) {
      for (int i = 0; i < tilemap.height; i++) {
        for (int j = 0; j < tilemap.width; j++) {
          int tileIndex = tilemap.map[layer][j][i];
          if (tileIndex >= 0 && tileIndex < loadedMediasTiles.length) {
            LoadedMediaTile tile = loadedMediasTiles[tileIndex];
            ui.Image? loadedMedia = tile.loadedMedia?.uiImage;
            ui.Rect? rect = tile.loadedMedia?.media
                .getTileRectPreSized(tile.index, tile.loadedMedia!.fullSize);

            if (controller.x + j * controller.tileSize < -controller.tileSize ||
                controller.x + j * controller.tileSize > size.width ||
                controller.y + i * controller.tileSize < -controller.tileSize ||
                controller.y + i * controller.tileSize > size.height) {
              continue;
            }
            if (loadedMedia != null && rect != null) {
              canvas.drawImageRect(
                loadedMedia,
                rect,
                Rect.fromLTWH(
                    j * controller.tileSize.toDouble() +
                        controller.x.toDouble(),
                    i * controller.tileSize.toDouble() +
                        controller.y.toDouble(),
                    controller.tileSize.toDouble(),
                    controller.tileSize.toDouble()),
                Paint(),
              );
            }
          }
        }
      }
    }

    // draw grid
    for (int i = 0; i < tilemap.height; i++) {
      for (int j = 0; j < tilemap.width; j++) {
        if (controller.x + j * controller.tileSize < -controller.tileSize ||
            controller.x + j * controller.tileSize > size.width ||
            controller.y + i * controller.tileSize < -controller.tileSize ||
            controller.y + i * controller.tileSize > size.height) {
          continue;
        }
        canvas.drawRect(
          Rect.fromLTWH(
              j * controller.tileSize.toDouble() + controller.x.toDouble(),
              i * controller.tileSize.toDouble() + controller.y.toDouble(),
              controller.tileSize.toDouble(),
              controller.tileSize.toDouble()),
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
