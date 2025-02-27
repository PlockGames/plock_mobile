import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_top_bar.dart';

import '../../games/media.dart';
import 'tilemap_editor.dart';

class TilemapEditorPage extends StatefulWidget {
  final List<Tile> tiles;
  final List<Media> medias;
  final Tilemap tilemap;
  final Function? onUpdate;

  int selectedTile = 0;

  TilemapEditorPage({required this.tilemap, required this.onUpdate, required this.tiles, required this.medias});

  @override
  _SpriteEditorPageState createState() => _SpriteEditorPageState();
}

class _SpriteEditorPageState extends State<TilemapEditorPage> {

  void onTapOnTileBar(int index) {
    setState(() {
      widget.selectedTile = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tilemap Editor'),
        ),
        body: Column(
          children: [
            TilemapEditorTopBar(tiles: widget.tiles, medias: widget.medias, selectedTile: widget.selectedTile, onTap: onTapOnTileBar),
            TilemapEditor(tiles: widget.tiles, medias: widget.medias, selectedTile: widget.selectedTile, tilemap: widget.tilemap),
          ],
        )
    );
  }
}