import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/image/LoadedImage.dart';
import 'package:plock_mobile/models/component_fields/image/part_image.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';

import '../games/media.dart';
import 'image/media_select.dart';

/// A Field that contain a Text value
class ComponentFieldImage extends ComponentField {

  /// The value of the field
  MediaSelect _value;

  ComponentFieldImage({
    required MediaSelect value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldText';

  @override
  Widget getField(String name, bool debug, List<Media> medias, Map<String, ComponentField> fields) {
    return ComponentFieldImageField(field: this, name: name, medias: medias);
  }

  @override
  ComponentFieldImage instance() {
    return ComponentFieldImage(value: _value, onUpdate: onUpdate);
  }

  @override
  MediaSelect get value => _value;

  @override
  set value(dynamic value) {
    _value = value;
  }

  @override
  String toJson() {
    String mediaSelect =  "{";
    mediaSelect += "\"name\": \"${_value.name}\",";
    mediaSelect += "\"index\": ${_value.index}";
    mediaSelect += "}";
    return mediaSelect;
  }

  @override
  void updateFromJson(dynamic jsonVal) {
    _value = MediaSelect();
    _value.name = jsonVal['name'];
    _value.index = jsonVal['index'];
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
    controller.text = widget.field.value.name;
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    Media? media;
    try {
      media = widget.medias.firstWhere((element) => element.name == widget.field.value.name);
    } catch (e) {
      media = null;
    }

    Future<LoadedImage?> loadImage() async {
      if (media == null || media?.file == null) {
        return null;
      }

      Uint8List image = await media!.file!.readAsBytes();
      Rect rect = await media!.getTileRect(widget.field.value.index);

      return LoadedImage(data: image, bounds: rect);
    }

    Future<LoadedImage?> future = loadImage();

    updateMedia() {
      Media? newMedia;
      try {
        newMedia = widget.medias.firstWhere((element) => element.name == widget.field.value.name);
      } catch (e) {
        newMedia = null;
      }

      if (newMedia != media) {
        setState(() {
          media = newMedia;
          future = loadImage();
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
            widget.field.value.name = text;
            if (widget.field.onUpdate != null) {
              widget.field.onUpdate!();
            }

            updateMedia();
          }
        ),
        if (media is MediaSet)
          TextField(
            decoration: const InputDecoration(
              labelText: 'Index',
            ),
            controller: TextEditingController(text: widget.field.value.index.toString()),
            onChanged: (text) {
              try {
                setState(() {
                  widget.field.value.index = int.parse(text);
                  if (widget.field.onUpdate != null) {
                    widget.field.onUpdate!();
                  }
                });
              } catch (e) {
                return;
              }

            }
          ),
        SizedBox.fromSize(size: const Size(0, 20)),
        if (future != null)
          FutureBuilder<LoadedImage?>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (media?.file == null) {
                  return const Text('No image');
                }

                if (media is MediaSet) {
                  return PartImage(snapshot.data!.data, snapshot.data!.bounds);
                } else {
                  return Image.memory(snapshot.data!.data);
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
      ]
    );
  }
}
