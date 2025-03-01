import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_editor_page.dart';
import 'package:plock_mobile/models/games/component_field.dart';

import '../games/media.dart';

/// A Field that contain a Text value
class ComponentFieldSprite extends ComponentField {

  /// The value of the field
   List<PlockSpriteAnimation> _value;

  ComponentFieldSprite({
    required List<PlockSpriteAnimation> value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldText';

  @override
  Widget getField(String name, bool debug, List<Media> medias, Map<String, ComponentField> fields) {
    return ComponentFieldSpriteField(field: this, name: name, medias: medias, onUpdate: onUpdate);
  }

  @override
  ComponentFieldSprite instance() {
    return ComponentFieldSprite(value: _value, onUpdate: onUpdate);
  }

  @override
  List<PlockSpriteAnimation> get value => _value;

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
    _value = jsonVal as List<PlockSpriteAnimation>;
  }

}

class ComponentFieldSpriteField extends StatefulWidget {
  final ComponentFieldSprite field;
  final String name;
  final List<Media> medias;
  final Function? onUpdate;

  ComponentFieldSpriteField({
    super.key,
    required this.field,
    required this.name,
    required this.medias,
    this.onUpdate,
  });

  @override
  _ComponentFieldSpriteFieldState createState() => _ComponentFieldSpriteFieldState();
}

class _ComponentFieldSpriteFieldState extends State<ComponentFieldSpriteField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var animation in widget.field.value)
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(animation.name),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.field.value.remove(animation);
                      if (widget.field.onUpdate != null) {
                        widget.field.onUpdate!();
                      }
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SpriteEditorPage(sprite: animation, onUpdate: widget.onUpdate, medias: widget.medias,)));
            },
          ),
        SizedBox(height: 10),
        FilledButton(onPressed: () {
          setState(() {
            widget.field.value.add(PlockSpriteAnimation(name: "New Animation"));
            if (widget.field.onUpdate != null) {
              widget.field.onUpdate!();
            }
          });
        }, child: Icon(Icons.add)
        ),
      ],

    );
  }
}