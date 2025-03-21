import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';

import 'dart:convert';

void main() {
  group('Vector2 Class Tests', () {
    test('Vector2 constructor initializes correctly', () {
      // Create a new instance of Vector2
      final vector = Vector2(2.0, 3.0);

      // Check that the x and y values are set correctly
      expect(vector.x, 2.0);
      expect(vector.y, 3.0);
    });

    test('toJson method returns correct JSON', () {
      // Create a new instance of Vector2
      final vector = Vector2(2.0, 3.0);

      // Check if the toJson method returns the correct JSON string
      final jsonString = vector.toJson();
      expect(jsonString, '{"x": 2.0, "y": 3.0}');
    });

    test('fromJson method creates Vector2 from JSON', () {
      // JSON representation of a Vector2
      final json = '{"x": 2.0, "y": 3.0}';

      // Create a new Vector2 object from the JSON
      final vector = Vector2.fromJson(jsonDecode(json));

      // Check that the Vector2 object has the correct values
      expect(vector.x, 2.0);
      expect(vector.y, 3.0);
    });

    test('fromJson handles invalid JSON gracefully', () {
      // Invalid JSON (avec une valeur non numérique pour 'x')
      final invalidJson = '{"x": "invalid", "y": 3.0}';

      try {
        // Tentative de création d'un Vector2 à partir de JSON invalide
        final vector = Vector2.fromJson(jsonDecode(invalidJson));

        // Si aucune erreur n'est lancée, le test échoue
        fail('Expected an error due to invalid JSON');
      } catch (e) {
        // Vérifier qu'une erreur a été lancée (sans spécifier le type exact)
        expect(e, isA<Error>());  // ou simplement ne pas vérifier le type
      }
    });
  });
}