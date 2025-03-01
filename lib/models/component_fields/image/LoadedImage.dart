import 'dart:typed_data';
import 'dart:ui';

class LoadedImage {
  final Uint8List data;
  final Rect bounds;

      LoadedImage({
  required this.data,
  required this.bounds,
});

}