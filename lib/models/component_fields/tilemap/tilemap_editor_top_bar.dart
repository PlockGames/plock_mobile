import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';

import '../../games/media.dart';

class TilemapEditorTopBar extends StatelessWidget {
  final List<Tile> tiles;
  final List<Image?> loadedMedias;
  final int selectedTile;
  final Function(int) onTap;

  TilemapEditorTopBar(
      {required this.tiles,
      required this.loadedMedias,
      this.selectedTile = 0,
      required this.onTap});

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Container(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tiles.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () {
                  // change mode from draw to move
                  onTap(-2);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          selectedTile == -2 ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(Icons.arrow_outward_rounded),
                ),
              );
            } else if (index == 1) {
              return GestureDetector(
                onTap: () {
                  onTap(-1);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          selectedTile == -1 ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(Icons.delete),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  onTap(index - 2);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedTile == index - 2
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: loadedMedias[index - 2] == null
                      ? Container()
                      : Image(
                          image: loadedMedias[index - 2]!.image,
                        ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
