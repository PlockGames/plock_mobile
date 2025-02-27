import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_editor_page.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tile.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_page.dart';
import 'package:plock_mobile/models/games/component_field.dart';

import '../games/media.dart';
import 'component_field_tileset.dart';

/// A Field that contain a Text value
class ComponentFieldTilemap extends ComponentField {

   /// The value of the field
   Tilemap _value;

   /// The list of the tiles
   ComponentFieldTileset tiles;

   ComponentFieldTilemap({
    required Tilemap value,
    required this.tiles,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldText';

  @override
  Widget getField(String name, bool debug, List<Media> medias) {
    return ComponentFieldTilemapField(field: this, name: name, medias: medias, onUpdate: onUpdate, tiles: tiles.value);
  }

  @override
  ComponentFieldTilemap instance() {
    Tilemap instanceValue = Tilemap(_value.map.length, _value.map[0].length);
    for (int i = 0; i < _value.map.length; i++) {
      for (int j = 0; j < _value.map[i].length; j++) {
        instanceValue.map[i][j] = _value.map[i][j];
      }
    }
    return ComponentFieldTilemap(value: instanceValue, onUpdate: onUpdate, tiles: tiles);
  }

  @override
  Tilemap get value => _value;

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
    _value = jsonVal as Tilemap;
  }

}

class ComponentFieldTilemapField extends StatelessWidget {
final ComponentFieldTilemap field;
  final String name;
  final List<Media> medias;
  final Function? onUpdate;
  final List<Tile> tiles;

  ComponentFieldTilemapField({
    required this.field,
    required this.name,
    required this.medias,
    required this.tiles,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TilemapEditorPage(tilemap: field.value, tiles: tiles, medias: medias, onUpdate: () {
            if (onUpdate != null) {
              onUpdate!();
            }
          }),
        ),
      );
    }, child: Text("Edit tilemap"));
  }
}