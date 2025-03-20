import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_tilemap.dart';
import 'package:plock_mobile/models/component_fields/component_field_tileset.dart';
import 'package:plock_mobile/models/component_flame/component_flame_tilemap.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import '../../pages/play/game_player_object.dart';
import '../component_fields/component_field_number.dart';
import '../component_fields/tilemap/tile.dart';
import '../component_fields/tilemap/tilemap.dart';
import '../games/component_type.dart';
import '../games/media.dart';

/// A component that contain an object level variable
class ComponentTilemap extends ComponentType {

  ComponentTilemap() {
    fields["size"] = ComponentFieldNumber(value: 1.0);
    fields["map"] = ComponentFieldTilemap(value: Tilemap(3, 2));
    fields["tiles"] = ComponentFieldTileset(value: List<Tile>.empty(growable: true));
  }

  @override
  String get type => 'ComponentTilemap';

  @override
  String get name => 'Tilemap';

  @override
  ComponentType instance() {
    ComponentTilemap comp = ComponentTilemap();
    fields.forEach((key, value) {
      comp.fields[key] = value.instance();
    });
    return comp;
  }

  @override
  DisplayComponents getDisplayComponent(List<Media> medias,
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {

    if (fields["map"] == null || fields["tiles"] == null) {
      return DisplayComponents(display: null, select: null);
    }

    var display = ComponentFlameTilemap(
        onDragStartCallback: onDragStartCallback,
        onTapeUpCallback: onTapeUpCallback,
        onDragCancelCallback: onDragCancelCallback,
        onDragEndCallback: onDragEndCallback,
        onDragUpdateCallback: onDragUpdateCallback,
        tilemap: fields["map"]!.value,
        tiles: fields["tiles"]!.value,
        size: Vector2(
            fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
        componentType: this,
        initScale: Vector2(
            fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
        medias: medias
    );

      return DisplayComponents(display: display, select: null);

  }

  @override
  Component? getGameDisplayComponent(List<Media> medias,
      onTapeUpCallback,
      onDragStartCallback,
      onDragUpdateCallback,
      onDragEndCallback,
      onDragCancelCallback) {

    if (fields["map"] == null || fields["tiles"] == null) {
      return null;
    }

    var display = ComponentFlameTilemap(
        onDragStartCallback: onDragStartCallback,
        onTapeUpCallback: onTapeUpCallback,
        onDragCancelCallback: onDragCancelCallback,
        onDragEndCallback: onDragEndCallback,
        onDragUpdateCallback: onDragUpdateCallback,
        tilemap: fields["map"]!.value,
        tiles: fields["tiles"]!.value,
        componentType: this,
        size: Vector2(
            fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
        initScale: Vector2(
            fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
        medias: medias
    );

    return display;

  }

  @override
  Future<GamePlayerObject> updateDisplay(Component? component,
      GamePlayerObject parent) async {
    return parent;
  }

}
