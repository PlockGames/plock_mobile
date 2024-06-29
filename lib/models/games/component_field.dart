import 'dart:convert';

import 'package:flutter/cupertino.dart';

/// A field (or value) of a component.
class ComponentField {

  /// The type of the field.
  String get type => 'Field';

  /// The function executed when the field is updated.
  Function? onUpdate;

  ComponentField({this.onUpdate});

  /// Return the widget to display the field in the editor.
  Widget getField(String name) {
    return Container();
  }

  /// Return a copy of the field.
  ComponentField instance() {
    return ComponentField(onUpdate: onUpdate);
  }

  /// Convert the field to a JSON string.
  String toJson() {
    return "";
  }

  /// update value from a json value
  void updateFromJson(dynamic jsonVal) {

  }

  /// Set the value of the field.
  set value(dynamic value) {}

  /// Get the value of the field.
  get value => null;
}