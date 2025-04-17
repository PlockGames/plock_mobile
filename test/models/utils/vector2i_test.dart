import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/utils/Vector2i.dart';

void main() {
  group('Vector2i Class Tests', () {
    test('Vector2i constructor initializes correctly', () {
      // Create a new instance of Vector2i
      final vector = Vector2i(2, 3);

      // Check that the x and y values are set correctly
      expect(vector.x, 2);
      expect(vector.y, 3);
    });

    test('Vector2i works with negative values', () {
      // Create a new instance of Vector2i with negative values
      final vector = Vector2i(-5, -10);

      // Check that the x and y values are set correctly
      expect(vector.x, -5);
      expect(vector.y, -10);
    });

    test('Vector2i works with zero values', () {
      // Create a new instance of Vector2i with zero values
      final vector = Vector2i(0, 0);

      // Check that the x and y values are set correctly
      expect(vector.x, 0);
      expect(vector.y, 0);
    });

    test('Vector2i x and y can be modified after initialization', () {
      // Create a new instance of Vector2i
      final vector = Vector2i(1, 1);

      // Modify the x and y values
      vector.x = 10;
      vector.y = 20;

      // Check that the values were updated correctly
      expect(vector.x, 10);
      expect(vector.y, 20);
    });
  });
}