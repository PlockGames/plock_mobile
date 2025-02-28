import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_page_loaded.dart';

import '../../games/media.dart';

class LoadedMedia {
  final Image image;
  final ui.Image uiImage;

  LoadedMedia({required this.image, required this.uiImage});
}

class TilemapEditorPage extends StatefulWidget {
  final List<Tile> tiles;
  final List<Media> medias;
  final Tilemap tilemap;
  final Function? onUpdate;

  TilemapEditorPage({required this.tilemap, required this.onUpdate, required this.tiles, required this.medias});

  @override
  _SpriteEditorPageState createState() => _SpriteEditorPageState();
}

class _SpriteEditorPageState extends State<TilemapEditorPage> {

  @override
  void initState() {
    super.initState();
  }

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

        Future<List<LoadedMedia?>> loadTilesMedias() async {
          List<Uint8List?> tiles = List<Uint8List?>.empty(growable: true);
          for (int i = 0; i < tilesMedia.length; i++) {
            if (tilesMedia[i] != null) {
              tiles.add(await tilesMedia[i]!.file?.readAsBytes());
            } else {
              tiles.add(null);
            }
          }

          List<ui.Image?> uiImages = List<ui.Image?>.empty(growable: true);
          for (int i = 0; i < tiles.length; i++) {
            if (tiles[i] != null) {
              uiImages.add(await decodeImageFromList(tiles[i]!));
            } else {
              uiImages.add(null);
            }
          }

          List<Image?> images = List<Image?>.empty(growable: true);
          for (int i = 0; i < tiles.length; i++) {
            if (tiles[i] != null) {
              images.add(Image.memory(tiles[i]!));
            } else {
              images.add(null);
            }
          }

          List<LoadedMedia?> loadedMedias = List<LoadedMedia?>.empty(growable: true);
          for (int i = 0; i < tiles.length; i++) {
            if (tiles[i] != null) {
              loadedMedias.add(LoadedMedia(image: images[i]!, uiImage: uiImages[i]!));
            } else {
              loadedMedias.add(null);
            }
          }
          return loadedMedias;
        }

        Future<List<LoadedMedia?>?> future = loadTilesMedias();

    return Scaffold(
        appBar: AppBar(
          title: Text('Tilemap Editor'),
        ),
        body: FutureBuilder<List<LoadedMedia?>?>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TilemapEditorPageLoaded(tilemap: widget.tilemap, onUpdate: widget.onUpdate, tiles: widget.tiles, loadedMedias: snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}