import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

class ComponentFieldNumber extends ComponentField {
int _value;

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
  Widget getField(String name) {
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
          _value = int.parse(text);
        }
        if (onUpdate != null) {
          onUpdate();
        }
      },
    );
  }

  @override
  ComponentFieldNumber instance() {
    return ComponentFieldNumber(value: _value, onUpdate: onUpdate);
  }

  @override
  String toJson() {
    return _value.toString();
  }

}