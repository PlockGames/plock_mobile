import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

/// A field that contain a (int) number value.
class ComponentFieldNumber extends ComponentField {
  /// The value of the field.
  double _value;

  ComponentFieldNumber({
    required value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldNumber';

  @override
  get value => _value;

  @override
  set value(dynamic value) {
    _value = value;
  }

  @override
  Widget getField(String name, bool debug) {
    return TextField(
      decoration: InputDecoration(
        labelText: name,
      ),
      keyboardType: TextInputType.number,
      controller: TextEditingController(text: _value.toString()),
      onChanged: (text) {
        if (text.isEmpty) {
          _value = 0;
        } else {
          _value = double.parse(text);
        }
        if (onUpdate != null) {
          onUpdate!();
        }
      },
    );
  }

  @override
  ComponentFieldNumber instance() {
    return ComponentFieldNumber(value: _value.toDouble(), onUpdate: onUpdate);
  }

  @override
  String toJson() {
    return _value.toString();
  }

  @override
  void updateFromJson(dynamic jsonVal) {
    _value = jsonVal.toDouble();
  }

}