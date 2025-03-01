import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PartImage extends StatefulWidget {
  Uint8List data;
  Rect rect;
  double width = 50;
  double height = 50;
  BoxFit fit = BoxFit.fill;

  PartImage(this.data, this.rect, {super.key, this.width = 0, this.height = 0, this.fit = BoxFit.fill}) {
    if (this.width == 0)
      this.width = this.rect.width;
    if (this.height == 0)
      this.height = this.rect.height;
  }

  @override
  _PartImageState createState() => _PartImageState();
}

class _PartImageState extends State<PartImage> {
  Future<ui.Image> getImage(Uint8List data) async {
    Completer<ImageInfo> completer = Completer();
    var img = new MemoryImage(data);
    img
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImage(widget.data),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return paintImage(snapshot.data);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  paintImage(image) {
    return CustomPaint(
      painter: ImagePainter(image, widget.rect, widget.fit),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  ui.Image resImage;
  BoxFit fit;

  Rect rectCrop;

  ImagePainter(this.resImage, this.rectCrop, this.fit);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Size imageSize =
    Size(resImage.width.toDouble(), resImage.height.toDouble());
    FittedSizes sizes = applyBoxFit(fit, imageSize, size);

    Rect inputSubRect = rectCrop;
    final Rect outputSubRect =
    Alignment.center.inscribe(sizes.destination, rect);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;
    canvas.drawRect(rect, paint);

    canvas.drawImageRect(resImage, inputSubRect, outputSubRect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}