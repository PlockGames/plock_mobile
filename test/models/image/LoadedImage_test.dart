import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/image/LoadedImage.dart';
void main() {
  group('LoadedImage Tests', () {
    test('Le constructeur initialise correctement les champs', () {
      // Création d'une instance de Uint8List avec quelques données
      final Uint8List testData = Uint8List.fromList([10, 20, 30, 40]);
      // Création d'un rectangle test (bounds)
      final Rect testBounds = Rect.fromLTWH(10.0, 20.0, 100.0, 200.0);

      // Création de l'instance LoadedImage
      final loadedImage = LoadedImage(data: testData, bounds: testBounds);

      // Vérifier que les données et les bounds sont correctement assignés
      expect(loadedImage.data, equals(testData));
      expect(loadedImage.bounds, equals(testBounds));
    });
  });
}
