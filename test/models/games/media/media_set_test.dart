import 'dart:math';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';

void main() {
  group('MediaSet', () {
    late MediaSet mediaSet;

    setUp(() {
      mediaSet = MediaSet(id: 1, name: 'Test MediaSet');
    });

    test('initialization with default values', () {
      expect(mediaSet.id, 1);
      expect(mediaSet.name, 'Test MediaSet');
      expect(mediaSet.tileWidth, 16);
      expect(mediaSet.tileHeight, 16);
      expect(mediaSet.offsetX, 0);
      expect(mediaSet.offsetY, 0);
      expect(mediaSet.gapX, 0);
      expect(mediaSet.gapY, 0);
    });

    test('getSize() returns correct tile size', () async {
      final size = await mediaSet.getSize();
      expect(size.x, 16.0);
      expect(size.y, 16.0);
    });

    test('getTileRectPreSized() calculates correct rect', () {
      final size = Vector2(32.0, 32.0);
      final rect = mediaSet.getTileRectPreSized(3, size);
      expect(rect.left, 16.0);
      expect(rect.top, 16.0);
      expect(rect.width, 16.0);
      expect(rect.height, 16.0);
    });

    test('getTileRectPreSized() with gaps calculates correct rect', () {
      mediaSet.gapX = 2;
      mediaSet.gapY = 2;
      final size = Vector2(32.0, 32.0);
      final rect = mediaSet.getTileRectPreSized(3, size);

      // Pour index 3 (2ème ligne, 2ème colonne dans une grille 2x2)
      // Calcul:
      // x = 1 * (tileWidth + gapX) = 1 * (16 + 2) = 18
      // y = 1 * (tileHeight + gapY) = 1 * (16 + 2) = 18
      expect(rect.left, 18.0);
      expect(rect.top, 18.0);
      expect(rect.width, 16.0);
      expect(rect.height, 16.0);
    });

    test('instance() creates copy with same properties', () {
      mediaSet.tileWidth = 32;
      mediaSet.tileHeight = 32;
      mediaSet.offsetX = 2;
      mediaSet.offsetY = 2;
      mediaSet.gapX = 1;
      mediaSet.gapY = 1;

      final newInstance = mediaSet.instance() as MediaSet;

      expect(newInstance.id, mediaSet.id);
      expect(newInstance.name, mediaSet.name);
      expect(newInstance.tileWidth, 32);
      expect(newInstance.tileHeight, 32);
      expect(newInstance.offsetX, 2);
      expect(newInstance.offsetY, 2);
      expect(newInstance.gapX, 1);
      expect(newInstance.gapY, 1);
    });
  });
}