import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/component_field.dart';

/// A Field that contain a Texture value
class ComponentFieldTexture extends ComponentField {

  /// The value of the field
  XFile? _value;

  ComponentFieldTexture({
    required XFile? value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldTexture';

  @override
  Widget getField(String name, bool debug) {
    return TextureField(value: _value, onUpdate: onUpdate, updateValue: updateValue);
  }

  @override
  ComponentFieldTexture instance() {
    return ComponentFieldTexture(value: _value, onUpdate: onUpdate);
  }

  void updateValue(XFile? newValue) {
    _value = newValue;
  }

  @override
  XFile? get value => _value;

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
    _value = jsonVal as XFile;
  }

}

class TextureField extends StatefulWidget {
  XFile? value;
  Function? onUpdate;
  Function? updateValue;

  TextureField({super.key, this.value, this.onUpdate, this.updateValue});

  @override
  State<StatefulWidget> createState() {
    return _TextureFieldState();
  }

}

class _TextureFieldState extends State<TextureField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(onPressed: () async {
          final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
          setState(() {
            widget.value = image;
          });
          if (widget.onUpdate != null) {
            widget.onUpdate!();
          }
          if (widget.updateValue != null) {
            widget.updateValue!(image);
          }
        },child: const Text("Pick Image")),
        widget.value == null ? const Text("No image selected") : Image.file(File(widget.value!.path)),
      ],
    );
  }
}