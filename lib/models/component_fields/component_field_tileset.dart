import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_editor_page.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/games/component_field.dart';

import '../games/media.dart';

/// A Field that contain a Text value
class ComponentFieldTileset extends ComponentField {

  /// The value of the field
   List<Tile> _value;

   ComponentFieldTileset({
    required List<Tile> value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldTileset';

  @override
  Widget getField(String name, bool debug, List<Media> medias) {
    return ComponentFieldTilesetField(field: this, name: name, medias: medias, onUpdate: onUpdate);
  }

  @override
  ComponentFieldTileset instance() {
    return ComponentFieldTileset(value: _value, onUpdate: onUpdate);
  }

  @override
  List<Tile> get value => _value;

  @override
  set value(dynamic value) {
    _value = value;
  }

  @override
  String toJson() {
    return "\"$_value\"";
  }

  @override
  void updateFromJson(dynamic jsonVal) {
    _value = jsonVal as List<Tile>;
  }

}

class ComponentFieldTilesetField extends StatefulWidget {
  final ComponentFieldTileset field;
  final String name;
  final List<Media> medias;
  final Function? onUpdate;

  List<FocusNode> focusNodes = List<FocusNode>.empty(growable: true);

  ComponentFieldTilesetField({
    super.key,
    required this.field,
    required this.name,
    required this.medias,
    this.onUpdate,
  });

  @override
  _ComponentFieldTilesetFieldState createState() => _ComponentFieldTilesetFieldState();
}

class _ComponentFieldTilesetFieldState extends State<ComponentFieldTilesetField> {
  List<TextEditingController> controllers = List<TextEditingController>.empty(growable: true);


  @override
  void initState() {
    super.initState();
    widget.focusNodes = List<FocusNode>.empty(growable: true);
    controllers = List<TextEditingController>.empty(growable: true);
    for (int i = 0; i < widget.field.value.length; i++) {
      FocusNode focusNode = FocusNode();
      widget.focusNodes.add(focusNode);

      TextEditingController controller = TextEditingController(text: widget.field.value[i].media);
      controllers.add(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Media?> tilesMedia = List<Media?>.empty(growable: true);

    for (int i = 0; i < widget.field.value.length; i++) {
      try {
        tilesMedia.add(widget.medias.firstWhere((element) => element.name == widget.field.value[i].media));
      } catch (e) {
        tilesMedia.add(null);
      }
    }

    Future<List<Uint8List?>> loadTilesMedias() async {
      List<Uint8List?> tiles = List<Uint8List?>.empty(growable: true);
      for (int i = 0; i < widget.field.value.length; i++) {
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
          if (snapshot.hasError) {
            return const Text('Error: failed to load tiles');
          } else if (snapshot.hasData) {
            return Column(
              children: [
                for (int i = 0; i < widget.field.value.length; i++)
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox.fromSize(
                            size: const Size(50, 50),
                            child: snapshot.data![i] != null ? Image.memory(snapshot.data![i]!) : const Text('')),
                        Expanded(child:
                        TextField(
                          focusNode: widget.focusNodes[i],
                          controller: controllers[i],
                          decoration: const InputDecoration(
                            labelText: 'Tile',
                          ),
                          onChanged: (value) {
                            setState(() {
                              widget.field.value[i].media = value;
                              if (widget.onUpdate != null) {
                                widget.onUpdate!();
                              }
                              widget.focusNodes[i].requestFocus();
                            });
                          },
                        )
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              widget.field.value.remove(widget.field.value[i]);
                              if (widget.field.onUpdate != null) {
                                widget.field.onUpdate!();
                              }
                              widget.focusNodes.removeAt(i);
                              controllers.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 10),
                FilledButton(onPressed: () {
                  setState(() {
                    Tile tile = Tile();
                    widget.focusNodes.add(FocusNode());
                    controllers.add(TextEditingController(text: tile.media));
                    widget.field.value.add(tile);
                    if (widget.field.onUpdate != null) {
                      widget.field.onUpdate!();
                    }
                  });
                }, child: Icon(Icons.add)
                ),
              ],
            );
          } else {
            return const Text('No data');
          }
        } else {
          return const CircularProgressIndicator();
        }
      } ,
    );
  }
}