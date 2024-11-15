import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/component_field.dart';

/// A Field that contain a Text value
class ComponentFieldTexture extends ComponentField {

  /// The value of the field
  String? _value;

  ComponentFieldTexture({
    required String? value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldTexture';

  @override
  Widget getField(String name, bool debug) {
    return TextureField();
  }

  @override
  ComponentFieldTexture instance() {
    return ComponentFieldTexture(value: _value, onUpdate: onUpdate);
  }

  @override
  String? get value => _value;

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

class TextureField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextureFieldState();
  }

}

class _TextureFieldState extends State<TextureField> {
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextButton(onPressed: () async {
            final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
            setState(() {
              _image = image;
            });
          },child: Text("Pick Image")),
          _image == null ? Text("No image selected") : Image.file(File(_image!.path)),
        ],
      ),
    );
  }
}