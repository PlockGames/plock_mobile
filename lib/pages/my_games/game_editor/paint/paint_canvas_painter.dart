import 'package:flutter/material.dart';

class PaintCanvasPainter extends CustomPainter {
  final PaintController controller;
  final int width;
  final int height;
  final double pixelSize;

  PaintCanvasPainter(this.controller, this.width, this.height, this.pixelSize);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // draw a grid
    paint.color = Colors.white;
    double pixelReelSize = pixelSize - 2;
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        double dx = x * pixelSize;
        double dy = y * pixelSize;
        canvas.drawRect(Rect.fromLTWH(dx, dy, pixelReelSize, pixelReelSize), paint);
      }
    }

    for (var stroke in controller.strokes) {
      paint.color = stroke.color;
      if (paint.color == Colors.transparent) {
        paint.color = Colors.white;
      }
      for (var i = 0; i < stroke.points.length - 1; i++) {
        var p = stroke.points[i];
        if (p.dx < 0 || p.dy < 0 || p.dx >= width || p.dy >= height) {
          continue;
        }
        canvas.drawRect(Rect.fromLTWH(p.dx * pixelSize, p.dy * pixelSize, pixelReelSize, pixelReelSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PaintController {
  final List<Stroke> strokes = List<Stroke>.empty(growable: true);
  final List<Stroke> undoneStrokes = List<Stroke>.empty(growable: true);
  Color color = Colors.red;
  bool isPainting = true;

  void addStroke(Stroke stroke) {
    if (isPainting) {
      stroke.color = Color.fromARGB(255, color.red, color.green, color.blue);
    } else {
      stroke.color = Colors.transparent;
    }
    strokes.add(stroke);
  }

  void setColor(Color color) {
    this.color = color;
  }

  void undo() {
    if (strokes.isNotEmpty) {
      undoneStrokes.add(strokes.removeLast());
    }
  }

  void redo() {
    if (undoneStrokes.isNotEmpty) {
      strokes.add(undoneStrokes.removeLast());
    }
  }
}

class Stroke {
  List<Offset> points = List<Offset>.empty(growable: true);
  Color color;

  Stroke({this.color = Colors.black});
}