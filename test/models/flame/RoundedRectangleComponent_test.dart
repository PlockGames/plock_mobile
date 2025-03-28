import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/flame/RoundedRectangleComponent.dart';

void main() {
  group('RoundedRectangleComponent Render Tests', () {
    testWithFlameGame('should render visible rounded rectangle when renderShape is true', (game) async {
      final component = RoundedRectangleComponent(
        width: 100,
        height: 50,
        radius: 10,
        paint: Paint()..color = Colors.blue,
      )..renderShape = true;

      await game.ensureAdd(component);
      game.onGameResize(Vector2(200, 200));

      // Vérifie que le composant est bien ajouté et visible
      expect(game.children.contains(component), isTrue);
      expect(component.renderShape, isTrue);
    });

    testWithFlameGame('should not render when renderShape is false', (game) async {
      final component = RoundedRectangleComponent(
        width: 100,
        height: 50,
        radius: 10,
        paint: Paint()..color = Colors.red,
      )..renderShape = false;

      await game.ensureAdd(component);
      game.onGameResize(Vector2(200, 200));

      // Le composant est dans l'arbre mais ne doit pas être rendu
      expect(game.children.contains(component), isTrue);
      expect(component.renderShape, isFalse);
    });

    testWithFlameGame('should render with correct dimensions', (game) async {
      final component = RoundedRectangleComponent(
        width: 150,
        height: 75,
        radius: 20,
        position: Vector2(50, 50),
        paint: Paint()..color = Colors.green,
      );

      await game.ensureAdd(component);
      game.onGameResize(Vector2(300, 300));

      // Vérification des propriétés dimensionnelles
      expect(component.width, 150);
      expect(component.height, 75);
      expect(component.radius, 20);
      expect(component.position, Vector2(50, 50));
    });

    testWithFlameGame('should apply paint properties correctly', (game) async {
      final testPaint = Paint()
        ..color = Colors.purple
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      final component = RoundedRectangleComponent(
        width: 100,
        height: 100,
        radius: 15,
        paint: testPaint,
      );

      await game.ensureAdd(component);

      expect(component.paint.color.value, Colors.purple.value);
      expect(component.paint.strokeWidth, 3.0);
      expect(component.paint.style, PaintingStyle.stroke);
    });

    testWithFlameGame('should handle transformations correctly', (game) async {
      final component = RoundedRectangleComponent(
        width: 80,
        height: 80,
        radius: 10,
        position: Vector2(100, 100),
        scale: Vector2(1.5, 1.5),
        angle: 0.5,
      );

      await game.ensureAdd(component);

      // Vérification des transformations
      expect(component.position, Vector2(100, 100));
      expect(component.scale, Vector2(1.5, 1.5));
      expect(component.angle, 0.5);
    });
  });
}