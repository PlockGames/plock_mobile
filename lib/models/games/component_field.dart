import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ComponentField {

  String get type => 'Field';
  var onUpdate;

  ComponentField({this.onUpdate});

  Widget getField(String name) {
    return Container();
  }

  ComponentField instance() {
    return ComponentField(onUpdate: onUpdate);
  }

  set value(dynamic value) {}
  get value => null;
}