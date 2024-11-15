import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

/// A Field that contain a Text value
class ComponentFieldText extends ComponentField {

  /// The value of the field
  String _value;

  ComponentFieldText({
    required String value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldText';

  @override
  Widget getField(String name, bool debug) {
    return TextField(
      decoration: InputDecoration(
        labelText: name,
      ),
      controller: TextEditingController(text: _value),
      onChanged: (text) {
        _value = text;
        if (onUpdate != null) {
          onUpdate!();
        }
      },
    );
  }

  @override
  ComponentFieldText instance() {
    return ComponentFieldText(value: _value, onUpdate: onUpdate);
  }

  @override
  String get value => _value;

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
    _value = jsonVal as String;
  }

}