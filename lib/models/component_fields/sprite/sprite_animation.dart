import 'package:plock_mobile/models/component_fields/image/media_select.dart';

class PlockSpriteAnimation {
  String name;
  List<MediaSelect> images = List<MediaSelect>.empty(growable: true);
  double fps = 0.1;

  PlockSpriteAnimation({
    required this.name,
  });
}