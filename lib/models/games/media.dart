import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../component_fields/image/LoadedImage.dart';
import '../component_fields/image/media_select.dart';
import '../utils/Vector2.dart';
import 'media/media_set.dart';

class Media {
  String uuid = "";
  final int id;
  String name;
  XFile? file;

  Media({
    required this.id,
    required this.name,
    this.file,
  });

  Media instance() {
    return Media(
      id: id,
      name: name,
      file: file,
    );
  }

  MediaSet toSet() {
    MediaSet mediaSet = MediaSet(
      id: id,
      name: name,
    );

    mediaSet.file = file;
    return mediaSet;
  }

  Future<Vector2> getFullSize() async {
    if (file != null) {
      var image = await file!.readAsBytes();
      ImageInfo img = ImageInfo(image: await decodeImageFromList(image));
      return Vector2(img.image.width.toDouble(), img.image.height.toDouble());
    }
    return Vector2(0, 0);
  }

  Future<Vector2> getSize() async {
    return getFullSize();
  }

  Future<Rect> getTileRect(int index) async {
    Vector2 size = await getSize();
    return Rect.fromLTWH(0, 0, size.x, size.y);
  }

  Rect getTileRectPreSized(int index, Vector2 size) {
    return Rect.fromLTWH(0, 0, size.x, size.y);
  }

  Future<LoadedImage?> getLoadedImage({int index = 0}) async {
    final Uint8List? image = await file?.readAsBytes();
    final rect = await getTileRect(index);

    if (image == null) {
      return null;
    }

    return LoadedImage(
      data: image,
      bounds: rect,
    );
  }

  Future<int> getNbTiles() async {
    return 1;
  }

  String toJson() {
    return """
    {
      "id": $id,
      "name": "$name",
      "uuid": "$uuid"
    }
    """;
  }

  Media.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        uuid = json['uuid'];

}