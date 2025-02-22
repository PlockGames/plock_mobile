import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_flame/component_flame_image.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import '../../pages/play/game_player_object.dart';
import '../component_fields/component_field_number.dart';
import '../games/component_type.dart';
import '../games/media.dart';

/// A component that contain an object level variable
class ComponentSprite extends ComponentType {

  ComponentSprite() {
    fields["size"] = ComponentFieldNumber(value: 1.0);
    fields["texture"] = ComponentFieldText(value: "");
  }

  @override
  String get type => 'ComponentSprite';

  @override
  String get name => 'Sprite';

  @override
  ComponentType instance() {
    ComponentSprite comp = ComponentSprite();
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
    if (fields["texture"]?.value == null) {
      return DisplayComponents(display: null, select: null);
    }

    Media? media;

    try {
      media = medias.firstWhere((element) => element.name ==
          fields["texture"]!.value);
    } catch (e) {
      print("Error: $e");
    }

    if (media == null) {
      return DisplayComponents(display: null, select: null);
    }

    ComponentFlameImage display = ComponentFlameImage(
        onDragStartCallback: onDragStartCallback,
        onTapeUpCallback: onTapeUpCallback,
        onDragCancelCallback: onDragCancelCallback,
        onDragEndCallback: onDragEndCallback,
        onDragUpdateCallback: onDragUpdateCallback,
        image: media.file,
        initScale: Vector2(
            fields["size"]!.value.toDouble(), fields["size"]!.value.toDouble()),
        componentType: this
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
    if (fields["texture"]?.value == null) {
      return null;
    }

    Media? media;
    try {
      print(medias);
      media = medias.firstWhere((element) => element.name ==
          fields["texture"]!.value);
    } catch (e) {
      print("Error: $e");
    }

    if (media == null) {
      return null;
    }

    double size = fields["size"]!.value.toDouble();
    return ComponentFlameImage(
        onDragStartCallback: onDragStartCallback,
        onTapeUpCallback: onTapeUpCallback,
        onDragCancelCallback: onDragCancelCallback,
        onDragEndCallback: onDragEndCallback,
        onDragUpdateCallback: onDragUpdateCallback,
        initScale: Vector2(size, size),
        image: media.file,
        componentType: this
    );
  }

  @override
  Future<GamePlayerObject> updateDisplay(Component? component,
      GamePlayerObject parent) async {
    if (component is ComponentFlameImage) {

      if (fields['texture'] != null) {
        late Media? media;
        try {
          media =
              parent.plockGame.medias.firstWhere((element) => element.name ==
                  fields['texture']!.value);
        } catch (e) {
          media = null;
        }
        if (media != null) {
          component.image = media.file;
        }
        if (component.image != null) {
          var img = await decodeImageFromList(
              await component.image!.readAsBytes());
          component.sprite = Sprite(img);
        }
      } else {
        component.sprite = null;
      }
    }
    return parent;
  }

}
