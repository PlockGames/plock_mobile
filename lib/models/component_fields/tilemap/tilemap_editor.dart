import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_loaded.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_painter.dart';

import '../../games/media.dart';
import 'tile.dart';
import 'tilemap.dart';
import 'tilemap_editor_controller.dart';

class TilemapEditor extends StatefulWidget {
  final List<Tile> tiles;
  final List<Media> medias;
  final int selectedTile;
  final Tilemap tilemap;
  final int tileSize = 32;

  final TilemapEditorController controller;

  TilemapEditor({required this.tiles, required this.medias, this.selectedTile = 0, required this.tilemap})
      : controller = TilemapEditorController(tileSize: 32, width: tilemap.width, height: tilemap.height);

  @override
  _TilemapEditorState createState() => _TilemapEditorState();
}

class _TilemapEditorState extends State<TilemapEditor> {



  @override
  Widget build(BuildContext context) {
    List<Media?> tilesMedia = List<Media>.empty(growable: true);
    for (int i = 0; i < widget.tiles.length; i++) {
      try {
        tilesMedia.add(widget.medias.firstWhere((element) => element.name == widget.tiles[i].media));
      } catch (e) {
        tilesMedia.add(null);
      }
    }

    Future<List<ui.Image?>> loadTilesMedias() async {
      List<ui.Image?> tiles = List<ui.Image?>.empty(growable: true);
      for (int i = 0; i < tilesMedia.length; i++) {
        if (tilesMedia[i] != null) {
          tiles.add(await decodeImageFromList(await tilesMedia[i]!.file!.readAsBytes()));
        } else {
          tiles.add(null);
        }
      }
      return tiles;
    }

    Future<List<ui.Image?>> future = loadTilesMedias();

    return FutureBuilder<List<ui.Image?>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
        return TilemapEditorLoaded(tiles: widget.tiles, loadedMedias: snapshot.data!, selectedTile: widget.selectedTile, tilemap: widget.tilemap);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}