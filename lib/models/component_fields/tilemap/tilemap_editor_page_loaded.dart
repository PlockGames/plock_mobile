import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_controller.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_page.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_top_bar.dart';

import 'tilemap_editor.dart';

class TilemapEditorPageLoaded extends StatefulWidget {
  final List<Tile> tiles;
  final List<LoadedMedia?> loadedMedias;
  final Tilemap tilemap;
  final Function? onUpdate;

  int selectedTile = 0;
  int selectedLayer = 0;
  TilemapEditorController controller = TilemapEditorController(tileSize: 32);

  TilemapEditorPageLoaded({required this.tilemap, required this.onUpdate, required this.tiles, required this.loadedMedias});

  @override
  _SpriteEditorPageLoadedState createState() => _SpriteEditorPageLoadedState();
}

class _SpriteEditorPageLoadedState extends State<TilemapEditorPageLoaded> {

  @override
  void initState() {
    super.initState();
    widget.controller = TilemapEditorController(tileSize: 32);
    widget.selectedTile = 0;
  }

  void onTapOnTileBar(int index) {
    setState(() {
      widget.selectedTile = index;
    });
  }

  void onTapOnLayerBar(int index) {
    setState(() {
      widget.selectedLayer = index;
    });
  }

  void setPos(int x, int y) {
    setState(() {
      widget.controller.x = x;
      widget.controller.y = y;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ui.Image?> uiImages = List<ui.Image?>.empty(growable: true);
    for (int i = 0; i < widget.loadedMedias.length; i++) {
      if (widget.loadedMedias[i] != null) {
        uiImages.add(widget.loadedMedias[i]!.uiImage);
      } else {
        uiImages.add(null);
      }
    }

    return Column(
          children: [
            TilemapEditorTopBar(tiles: widget.tiles, loadedMedias: widget.loadedMedias, selectedTile: widget.selectedTile, onTap: onTapOnTileBar, selectedLayer: widget.selectedLayer, onTapLayer: onTapOnLayerBar),
            TilemapEditor(tiles: widget.tiles, loadedMedias: widget.loadedMedias, selectedTile: widget.selectedTile, tilemap: widget.tilemap, controller: widget.controller, setPos: setPos, selectedLayer: widget.selectedLayer),
          ],
        );
  }
}