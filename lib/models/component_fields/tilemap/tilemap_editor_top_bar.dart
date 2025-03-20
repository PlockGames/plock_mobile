import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/image/part_image.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_page.dart';

import 'loaded_media_tile.dart';
import 'tilemap.dart';

class TilemapEditorTopBar extends StatelessWidget {
  final List<Tile> tiles;
  final List<LoadedMedia?> loadedMedias;
  final int selectedTile;
  final int selectedLayer;
  final Function(int) onTap;
  final Function(int) onTapLayer;

  TilemapEditorTopBar(
      {required this.tiles,
      required this.loadedMedias,
      this.selectedTile = 0,
      this.selectedLayer = 0,
      required this.onTap,
      required this.onTapLayer
      });

  @override
  Widget build(BuildContext context) {
    int count = 0;
    List<LoadedMediaTile> loadedMediasTiles =
        List<LoadedMediaTile>.empty(growable: true);

    for (int i = 0; i < loadedMedias.length; i++) {
      if (loadedMedias[i] != null) {
        count += loadedMedias[i]!.count;

        for (int j = 0; j < loadedMedias[i]!.count; j++) {
          loadedMediasTiles
              .add(LoadedMediaTile(loadedMedia: loadedMedias[i], index: j));
        }
      } else {
        count += 1;
      }
    }

    return Column(
      children: [
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: Tilemap.NB_LAYERS,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onTapLayer(index);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedLayer == index
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text('${index + 1}'),
                ),
              );
            },
          ),
        ),

        ListTile(
          title: Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count + 2,
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
                          color: selectedTile == -2
                              ? Colors.blue
                              : Colors.transparent,
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
                          color: selectedTile == -1
                              ? Colors.blue
                              : Colors.transparent,
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
                      child: loadedMediasTiles[index - 2].loadedMedia == null
                          ? Container()
                          : PartImage(
                              loadedMediasTiles[index - 2].loadedMedia!.image,
                              loadedMediasTiles[index - 2]
                                  .loadedMedia!
                                  .media
                                  .getTileRectPreSized(
                                      loadedMediasTiles[index - 2].index,
                                      loadedMediasTiles[index - 2]
                                          .loadedMedia!
                                          .fullSize),
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
