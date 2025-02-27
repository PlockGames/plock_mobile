import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';

import '../../games/media.dart';

class TilemapEditorTopBar extends StatelessWidget {
  final List<Tile> tiles;
  final List<Media> medias;
  final int selectedTile;
  final Function(int) onTap;

  TilemapEditorTopBar({required this.tiles, required this.medias, this.selectedTile = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Media?> tilesMedia = List<Media>.empty(growable: true);
    for (int i = 0; i < tiles.length; i++) {
      try {
        tilesMedia.add(medias.firstWhere((element) => element.name == tiles[i].media));
      } catch (e) {
        tilesMedia.add(null);
      }
    }

    Future<List<Uint8List?>> loadTilesMedias() async {
      List<Uint8List?> tiles = List<Uint8List?>.empty(growable: true);
      for (int i = 0; i < tilesMedia.length; i++) {
        if (tilesMedia[i] != null) {
          tiles.add(await tilesMedia[i]!.file?.readAsBytes());
        } else {
          tiles.add(null);
        }
      }
      return tiles;
    }

    Future<List<Uint8List?>?> future = loadTilesMedias();

    return FutureBuilder<List<Uint8List?>?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListTile(
            title: Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onTap(index);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedTile == index ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Image.memory(snapshot.data![index]!),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}