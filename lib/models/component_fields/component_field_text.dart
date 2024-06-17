import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

class ComponentFieldText extends ComponentField {
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
  Widget getField(String name) {
    return TextField(
      decoration: InputDecoration(
        labelText: name,
      ),
      controller: TextEditingController(text: _value),
      onChanged: (text) {
        _value = text;
        onUpdate();
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
}