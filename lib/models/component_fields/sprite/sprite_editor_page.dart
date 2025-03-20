import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/image/LoadedImage.dart';
import 'package:plock_mobile/models/component_fields/image/media_select.dart';
import 'package:plock_mobile/models/component_fields/image/part_image.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';

import '../../games/media.dart';

class SpriteEditorPage extends StatefulWidget {
  final List<Media> medias;
  final PlockSpriteAnimation sprite;
  final Function? onUpdate;

  SpriteEditorPage({required this.sprite, required this.onUpdate, required this.medias});

  @override
  _SpriteEditorPageState createState() => _SpriteEditorPageState();
}

class _SpriteEditorPageState extends State<SpriteEditorPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: widget.sprite.name);

    List<Media?> getImages() {
      return widget.sprite.images.map((e) {
        try {
          return widget.medias.firstWhere((element) => element.name == e.name);
        } catch (e) {
          return null;
        }
      }).toList();
    }

    List<Media?> images = getImages();

    List<Future<LoadedImage?>> loadImages() {
      List<Future<LoadedImage?>> loadedImages = [];
      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          loadedImages.add(images[i]!.getLoadedImage(index: widget.sprite.images[i].index));
        } else {
          loadedImages.add(Future.value(null));
        }
      }
      return loadedImages;
    }

    List<Future<LoadedImage?>> future = loadImages();


    return Scaffold(
      appBar: AppBar(
        title: Text('Sprite Editor'),
      ),
      body: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  setState(() {
                    widget.sprite.name = value;
                    if (widget.onUpdate != null) {
                      widget.onUpdate!();
                    }
                  });
                },
              ),

              for (int i = 0; i < widget.sprite.images.length; i++)
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<LoadedImage?>(
                        future: future[i],
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              return PartImage(snapshot.data!.data, snapshot.data!.bounds, width: 40, height: 40, fit: BoxFit.contain);
                            } else {
                              return SizedBox(width: 40, height: 40);
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      Expanded(child:
                        TextField(
                          controller: TextEditingController(text: widget.sprite.images[i].name),
                          decoration: const InputDecoration(
                            labelText: 'Image',
                          ),
                          onChanged: (value) {
                            widget.sprite.images[i].name = value;
                            if (widget.onUpdate != null) {
                              widget.onUpdate!();
                            }
                          },
                        ),
                      ),
                      if (images[i] != null && images[i]! is MediaSet)
                        Expanded(child:
                        TextField(
                          controller: TextEditingController(text: widget.sprite.images[i].index.toString()),
                          decoration: const InputDecoration(
                            labelText: 'Tile Size',
                          ),
                          onChanged: (value) {
                            try {
                              setState(() {
                                widget.sprite.images[i].index = int.parse(value);
                                if (widget.onUpdate != null) {
                                  widget.onUpdate!();
                                }
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.sprite.images.removeAt(i);
                            if (widget.onUpdate != null) {
                              widget.onUpdate!();
                            };
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.sprite.images.add(MediaSelect());
                    images = getImages();
                    future = loadImages();
                    if (widget.onUpdate != null) {
                      widget.onUpdate!();
                    }
                  });
                },
                child: Icon(Icons.add),
              ),
            ],
          )
        );
  }
}