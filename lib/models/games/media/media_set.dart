import 'dart:ui';

import '../../utils/Vector2.dart';
import '../media.dart';

class MediaSet extends Media {
  int tileWidth = 16;
  int tileHeight = 16;
  int offsetX = 0;
  int offsetY = 0;
  int gapX = 0;
  int gapY = 0;

  MediaSet({required super.id, required super.name});

  @override
  Future<Vector2> getSize() async {
    return Vector2(tileWidth.toDouble(), tileHeight.toDouble());
  }

  @override
  Future<Rect> getTileRect(int index) async {
    Vector2 size = await getFullSize();
    return getTileRectPreSized(index, size);
  }

  @override
  Rect getTileRectPreSized(int index, Vector2 size) {
    int x = index % (size.x ~/ tileWidth == 0 ? 1 : size.x ~/ tileWidth);
    int y = index ~/ (size.x ~/ tileWidth == 0 ? 1 : size.x ~/ tileWidth);
    return Rect.fromLTWH(
        (x * tileWidth + offsetX + x * gapX).toDouble(),
        (y * tileHeight + offsetY + y * gapY).toDouble(),
        tileWidth.toDouble(),
        tileHeight.toDouble());
  }

  @override
  Future<int> getNbTiles() async {
    Vector2 size = await getFullSize();
    return (size.x ~/ tileWidth == 0 ? 1 : size.x ~/ tileWidth) * (size.y ~/ tileHeight == 0 ? 1 : size.y ~/ tileHeight);
  }

  @override
  Media instance() {
    final set = MediaSet(
      id: id,
      name: name,
    );

    set.file = file;
    set.tileWidth = tileWidth;
    set.tileHeight = tileHeight;
    set.offsetX = offsetX;
    set.offsetY = offsetY;
    set.gapX = gapX;
    set.gapY = gapY;

    return set;
  }

  @override
  String toJson() {
    String json = "{";
    json += "\"isSet\": true,";
    json += "\"id\": $id,";
    json += "\"name\": \"$name\",";
    json += "\"uuid\": \"$uuid\",";
    json += "\"tileWidth\": $tileWidth,";
    json += "\"tileHeight\": $tileHeight,";
    json += "\"offsetX\": $offsetX,";
    json += "\"offsetY\": $offsetY,";
    json += "\"gapX\": $gapX,";
    json += "\"gapY\": $gapY";
    json += "}";
    return json;
  }

  @override
  MediaSet.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    tileWidth = json['tileWidth'];
    tileHeight = json['tileHeight'];
    offsetX = json['offsetX'];
    offsetY = json['offsetY'];
    gapX = json['gapX'];
    gapY = json['gapY'];
  }
}