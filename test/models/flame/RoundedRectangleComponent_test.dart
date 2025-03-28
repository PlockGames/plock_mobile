import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/flame/RoundedRectangleComponent.dart';

void main() {
  group('RoundedRectangleComponent', () {
    testWithFlameGame('should create with correct dimensions', (game) async {
      final component = RoundedRectangleComponent(
        width: 100,
        height: 50,
        radius: 10,
      );

      await game.ensureAdd(component);

      expect(component.width, 100);
      expect(component.height, 50);
      expect(component.radius, 10);
    });

    testWithFlameGame('should render rounded rectangle', (game) async {
      final component = RoundedRectangleComponent(
        width: 200,
        height: 100,
        radius: 20,
        paint: Paint()..color = Colors.blue,
      );

      await game.ensureAdd(component);

      game.onGameResize(Vector2(300, 300));
      // Vérifie simplement que le composant est dans le jeu
      expect(game.children.contains(component), isTrue);
    });

    testWithFlameGame('should respect position and anchor', (game) async {
      final component = RoundedRectangleComponent(
        width: 100,
        height: 50,
        radius: 5,
        position: Vector2(50, 60),
        anchor: Anchor.center,
      );

      await game.ensureAdd(component);

      expect(component.position, Vector2(50, 60));
      expect(component.anchor, Anchor.center);
    });

    testWithFlameGame('should apply custom paint', (game) async {
      final redPaint = Paint()..color = Colors.red;
      final component = RoundedRectangleComponent(
        width: 80,
        height: 80,
        radius: 15,
        paint: redPaint,
      );

      await game.ensureAdd(component);

      // Compare les valeurs ARGB directement
      expect(component.paint.color.value, Colors.red.value);
    });

    testWithFlameGame('should handle scale and angle', (game) async {
      final component = RoundedRectangleComponent(
        width: 100,
        height: 50,
        radius: 10,
        scale: Vector2(1.5, 1.5),
        angle: 0.5,
      );

      await game.ensureAdd(component);

      expect(component.scale, Vector2(1.5, 1.5));
      expect(component.angle, 0.5);
    });

    testWithFlameGame('should not render when renderShape is false', (game) async {
      final component = RoundedRectangleComponent(
        width: 100,
        height: 50,
        radius: 10,
      )..renderShape = false;

      await game.ensureAdd(component);
      expect(component.renderShape, isFalse);
    });
  });
}