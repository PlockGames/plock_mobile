import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

class ComponentFieldText extends ComponentField {
String value;

  ComponentFieldText({
    required this.value,
  });

  @override
  String get type => 'ComponentFieldText';

  @override
  Widget getField(String name) {
    return TextField(
      decoration: InputDecoration(
        labelText: name,
      ),
      controller: TextEditingController(text: value),
      onChanged: (text) {
        value = text;
      },
    );
  }

  @override
  ComponentFieldText instance() {
    return ComponentFieldText(value: value);
  }

}