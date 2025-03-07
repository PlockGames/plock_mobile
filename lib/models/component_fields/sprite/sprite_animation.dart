import 'package:plock_mobile/models/component_fields/image/media_select.dart';

class PlockSpriteAnimation {
  String name;
  List<MediaSelect> images = List<MediaSelect>.empty(growable: true);
  double fps = 0.1;

  PlockSpriteAnimation({
    required this.name,
  });

  PlockSpriteAnimation.fromJson(Map<String, dynamic> json) : name = json['name'] {
    for (var image in json['images']) {
      images.add(MediaSelect.fromJson(image));
    }
    fps = json['fps'];
  }

  String toJson() {
    String res = """
    {
      "name": "$name",
      "images": [
    """;
    for (int i = 0; i < images.length; i++) {
      res += images[i].toJson();
      if (i != images.length - 1) {
        res += ",";
      }
    }
    res += """
      ],
      "fps": $fps
    }
    """;
    return res;
  }
}