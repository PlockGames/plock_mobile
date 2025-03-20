import 'package:flutter/material.dart';
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

   ComponentFieldTilemap({
    required Tilemap value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldText';

  @override
  Widget getField(String name, bool debug, List<Media> medias, Map<String, ComponentField> fields) {
    var tiles = fields['tiles'] as ComponentFieldTileset;
    return ComponentFieldTilemapField(field: this, name: name, medias: medias, onUpdate: onUpdate, tiles: tiles.value);
  }

  @override
  ComponentFieldTilemap instance() {
    Tilemap instanceValue = Tilemap(_value.map[0].length, _value.map[0][0].length);
    for (int i = 0; i < Tilemap.NB_LAYERS; i++) {
      for (int j = 0; j < _value.map[i].length; j++) {
        for (int k = 0; k < _value.map[i][j].length; k++) {
          instanceValue.map[i][j][k] = _value.map[i][j][k];
        }
      }
    }
    return ComponentFieldTilemap(value: instanceValue, onUpdate: onUpdate);
  }

  @override
  Tilemap get value => _value;

  @override
  set value(dynamic value) {
    _value = value;
  }

  @override
  String toJson() {
    String res = "{";
    res += "\"map\": [";
    for (int i = 0; i < _value.map.length; i++) {
      res += "[";
      for (int j = 0; j < _value.map[i].length; j++) {
        res += "[";
        for (int k = 0; k < _value.map[i][j].length; k++) {
          res += "${_value.map[i][j][k]}";
          if (k < _value.map[i][j].length - 1) {
            res += ",";
          }
        }
        res += "]";
        if (j < _value.map[i].length - 1) {
          res += ",";
        }
      }
      res += "]";
      if (i < _value.map.length - 1) {
        res += ",";
      }
    }
    res += "]";
    res += "}";
    return res;
  }

  @override
  void updateFromJson(dynamic jsonVal) {
    _value = Tilemap(jsonVal['map'][0].length, jsonVal['map'][0][0].length);
    for (int i = 0; i < jsonVal['map'].length; i++) {
      for (int j = 0; j < jsonVal['map'][i].length; j++) {
        for (int k = 0; k < jsonVal['map'][i][j].length; k++) {
          _value.map[i][j][k] = jsonVal['map'][i][j][k];
        }
      }
    }
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