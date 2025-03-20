import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/media.dart';

import '../../utils/Vector2.dart';
import '../tilemap/tile.dart';
import 'tileset_editor_page_loaded.dart';

class LoadedMediaTile {
  final ui.Image image;
  final int nbTiles;
  final Size size;

  LoadedMediaTile({required this.size, required this.image, required this.nbTiles});
}

/// The TilesetEditorPage is a StatefulWidget that allows the user to edit a tileset collisions
class TilesetEditorPage extends StatefulWidget {
  final Tile tile;
  final List<Media> medias;

  TilesetEditorPage({required this.tile, required this.medias});

  @override
  _TilesetEditorPageState createState() => _TilesetEditorPageState();
}

/// The state of the TilesetEditorPage
class _TilesetEditorPageState extends State<TilesetEditorPage> {


  @override
  Widget build(BuildContext context) {
    Media?  media;
    try {
      media = widget.medias.firstWhere((element) => element.name == widget.tile.media);
    } catch (e) {
      media = null;
    }

    if (media == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Tileset Editor'),
        ),
        body: Center(
          child: Text('No media found'),
        ),
      );
    }

    Future<LoadedMediaTile?> loadImage(Media media) async {
      final data = await media.getLoadedImage();
      if (data != null) {
        Vector2 size = await media.getSize();
        LoadedMediaTile loadedMediaTile = LoadedMediaTile(
          image: await decodeImageFromList(data.data),
          nbTiles: await media.getNbTiles(),
          size: Size(size.x.toDouble(), size.y.toDouble()),
        );
        return loadedMediaTile;
      }
      return null;
    }

    final future = loadImage(media);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tileset Editor'),
      ),
      body: Center(
        child: FutureBuilder<LoadedMediaTile?>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TilesetEditorPageLoaded(
                tile: widget.tile,
                image: snapshot.data!,
                media: media!,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }



}