import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

class ComponentFieldNumber extends ComponentField {
int value;

  ComponentFieldNumber({
    required this.value,
  });

  @override
  String get type => 'ComponentFieldNumber';

  @override
  Widget getField(String name) {
    return TextField(
      decoration: InputDecoration(
        labelText: name,
      ),
      keyboardType: TextInputType.number,
      controller: TextEditingController(text: value.toString()),
      onChanged: (text) {
        value = int.parse(text);
      },
    );
  }

  @override
  ComponentFieldNumber instance() {
    return ComponentFieldNumber(value: value);
  }
}