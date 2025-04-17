import 'package:plock_mobile/models/component_fields/image/media_select.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MediaSelect Tests', () {
    test('Le constructeur par défaut initialise les valeurs correctement', () {
      final media = MediaSelect();
      expect(media.name, equals(''));
      expect(media.index, equals(0));
    });

    test('La méthode fromJson initialise correctement les champs', () {
      final Map<String, dynamic> jsonMap = {
        'name': 'Test Media',
        'index': 3,
      };
      final media = MediaSelect.fromJson(jsonMap);
      expect(media.name, equals('Test Media'));
      expect(media.index, equals(3));
    });

    test('La méthode toJson retourne une chaîne JSON valide', () {
      final media = MediaSelect();
      media.name = 'Example';
      media.index = 5;
      final jsonString = media.toJson();

      // On utilise jsonDecode pour vérifier le contenu de la chaîne JSON.
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      expect(decoded['name'], equals('Example'));
      expect(decoded['index'], equals(5));
    });
  });
}