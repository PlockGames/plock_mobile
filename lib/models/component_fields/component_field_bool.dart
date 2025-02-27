import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

import '../games/media.dart';

/// A Field that contain a Text value
class ComponentFieldBool extends ComponentField {

  /// The value of the field
  bool _value;

  ComponentFieldBool({
    required bool value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldBool';

  @override
  Widget getField(String name, bool debug, List<Media> medias) {
    return ComponentFieldBoolField(field: this, name: name, medias: medias);
  }

  @override
  ComponentFieldBool instance() {
    return ComponentFieldBool(value: _value, onUpdate: onUpdate);
  }

  @override
  bool get value => _value;

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
    _value = jsonVal as bool;
  }

}

class ComponentFieldBoolField extends StatefulWidget {
  final ComponentFieldBool field;
  final String name;
  final List<Media> medias;

  ComponentFieldBoolField({
    super.key,
    required this.field,
    required this.name,
    required this.medias,
  });

  @override
  _ComponentFieldBoolFieldState createState() => _ComponentFieldBoolFieldState();
}

class _ComponentFieldBoolFieldState extends State<ComponentFieldBoolField> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.name),
      value: widget.field.value,
      onChanged: (bool? value) {
        setState(() {
          widget.field.value = value!;
          if (widget.field.onUpdate != null) {
            widget.field.onUpdate!();
          }
        });
      },
    );
  }
}