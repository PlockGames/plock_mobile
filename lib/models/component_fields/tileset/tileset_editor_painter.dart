import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';

import '../../games/media.dart';
import '../tilemap/tile.dart';
import 'tileset_editor_page.dart';

class TilesetEditorPainter extends CustomPainter {
  final Tile tile;
  final LoadedMediaTile image;
  final Offset offset;
  final Media media;

  static const int TILE_SIZE = 32;

  TilesetEditorPainter(this.tile, this.image, this.media, {this.offset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    paint.strokeWidth = 1;
    int imageWidth = image.image.width;
    int imageHeight = image.image.height;
    int nbTilesHorizontally = 1;
    int nbTilesVertically = 1;

    if (media is MediaSet) {
      MediaSet mediaSet = media as MediaSet;
      double scale = TILE_SIZE / mediaSet.tileWidth;
      imageWidth = (image.image.width * scale).toInt();
      imageHeight = (image.image.height * scale).toInt();
      nbTilesHorizontally = image.image.width ~/ mediaSet.tileWidth;
      nbTilesVertically = image.image.height ~/ mediaSet.tileHeight;
    }
    canvas.drawImageRect(image.image, Rect.fromLTWH(0, 0, image.image.width.toDouble(), image.image.height.toDouble()), Rect.fromLTWH(0, 0, imageWidth.toDouble(), imageHeight.toDouble()), paint);

    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < tile.collision.length; i++) {
      int x = i % nbTilesHorizontally;
      int y = i ~/ nbTilesHorizontally;

      paint.color = Colors.green;
      canvas.drawRect(Rect.fromLTWH(x.toDouble() * TILE_SIZE, y.toDouble() * TILE_SIZE, TILE_SIZE.toDouble(), TILE_SIZE.toDouble()), paint);
    }

    for (int i = 0; i < tile.collision.length; i++) {
      int x = i % nbTilesHorizontally;
      int y = i ~/ nbTilesHorizontally;
      if (tile.collision[i] == true) {
        paint.color = Colors.red;
        canvas.drawRect(Rect.fromLTWH(x.toDouble() * TILE_SIZE, y.toDouble() * TILE_SIZE, TILE_SIZE.toDouble(), TILE_SIZE.toDouble()), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}