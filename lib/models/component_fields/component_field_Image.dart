import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

import '../games/media.dart';

/// A Field that contain a Text value
class ComponentFieldImage extends ComponentField {

  /// The value of the field
  String _value;

  ComponentFieldImage({
    required String value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldText';

  @override
  Widget getField(String name, bool debug, List<Media> medias) {
    return ComponentFieldImageField(field: this, name: name, medias: medias);
  }

  @override
  ComponentFieldImage instance() {
    return ComponentFieldImage(value: _value, onUpdate: onUpdate);
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

class ComponentFieldImageField extends StatefulWidget {
  final ComponentFieldImage field;
  final String name;
  final List<Media> medias;

  ComponentFieldImageField({
    super.key,
    required this.field,
    required this.name,
    required this.medias,
  });

  @override
  _ComponentFieldImageFieldState createState() => _ComponentFieldImageFieldState();
}

class _ComponentFieldImageFieldState extends State<ComponentFieldImageField> {
  final TextEditingController controller;
  FocusNode? focusNode;

  _ComponentFieldImageFieldState() : controller=TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.field.value;
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    Media? media;
    try {
      media = widget.medias.firstWhere((element) => element.name == widget.field.value);
    } catch (e) {
      media = null;
    }

    Future<Uint8List>? future = media?.file?.readAsBytes();

    updateMedia() {
      Media? newMedia;
      try {
        newMedia = widget.medias.firstWhere((element) => element.name == widget.field.value);
      } catch (e) {
        newMedia = null;
      }

      if (newMedia != media) {
        setState(() {
          media = newMedia;
          future = media?.file?.readAsBytes();
        });
      }
    }

    return Column(
      children: [
        TextField(
          focusNode: focusNode,
          decoration: InputDecoration(
          labelText: widget.name,
          ),
          controller: controller,
          onChanged: (text) {
            widget.field.value = text;
            if (widget.field.onUpdate != null) {
              widget.field.onUpdate!();
            }

            updateMedia();
            //focusNode.requestFocus();
          }
        ),
        SizedBox.fromSize(size: const Size(0, 20)),
        if (future != null)
          FutureBuilder<Uint8List>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(snapshot.data!);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
      ]
    );
  }
}