import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class RoundedRectangleComponent extends ShapeComponent {
  final double width;
  final double height;
  final double radius;

  RoundedRectangleComponent({
    required this.width,
    required this.height,
    required this.radius,
    super.anchor,
    super.angle,
    super.children,
    super.key,
    super.paint,
    super.paintLayers,
    super.position,
    super.priority,
    super.scale,
    super.size,
  });

  @override
  void render(Canvas canvas) {
    if (renderShape) {
      final rect = Rect.fromLTWH(0, 0, width, height);
      final roundedRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(roundedRect, paint);
    }
    super.render(canvas);
  }
}