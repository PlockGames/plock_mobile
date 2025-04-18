import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/component_fields/image/LoadedImage.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'package:plock_mobile/models/utils/Vector2.dart';

void main() {
  group('Media', () {
    late Media media;
    late XFile mockFile;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Image de test en base64 (un pixel blanc)
      final base64Image = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';
      final imageData = base64Decode(base64Image);

      // Crée un fichier temporaire avec les données de l'image
      final tempFile = await File.fromUri(Uri.file('test_image.png')).writeAsBytes(imageData);
      mockFile = XFile(tempFile.path);

      media = Media(
        id: 1,
        name: 'Test Media',
        file: mockFile,
      );
    });

    tearDown(() async {
      await File.fromUri(Uri.file('test_image.png')).delete();
    });

    test('instance() creates a copy', () {
      final copy = media.instance();
      expect(copy.id, media.id);
      expect(copy.name, media.name);
      expect(copy.file, media.file);
    });

    test('toSet() creates a MediaSet', () {
      final mediaSet = media.toSet();
      expect(mediaSet.id, media.id);
      expect(mediaSet.name, media.name);
      expect(mediaSet.file, media.file);
    });

    test('getFullSize() returns correct size', () async {
      final size = await media.getFullSize();
      expect(size.x, 1);
      expect(size.y, 1);
    });

    test('getSize() returns getFullSize()', () async {
      final size1 = await media.getSize();
      final size2 = await media.getFullSize();
      expect(size1.x, size2.x);
      expect(size1.y, size2.y);
    });

    test('getTileRect() returns correct rect', () async {
      final rect = await media.getTileRect(0);
      final size = await media.getSize();
      expect(rect, Rect.fromLTWH(0, 0, size.x, size.y));
    });

    test('getTileRectPreSized() returns correct rect', () {
      final size = Vector2(10, 20);
      final rect = media.getTileRectPreSized(0, size);
      expect(rect, Rect.fromLTWH(0, 0, size.x, size.y));
    });

    test('getLoadedImage() returns LoadedImage', () async {
      final loadedImage = await media.getLoadedImage();
      expect(loadedImage, isA<LoadedImage>());
      expect(loadedImage!.data, await media.file!.readAsBytes());
      expect(loadedImage.bounds, await media.getTileRect(0));
    });

    test('getLoadedImage() returns null if file is null', () async {
      media.file = null;
      final loadedImage = await media.getLoadedImage();
      expect(loadedImage, isNull);
    });

    test('getNbTiles() returns 1', () async {
      final nbTiles = await media.getNbTiles();
      expect(nbTiles, 1);
    });

    test('toJson() returns correct JSON string', () {
      final jsonString = media.toJson();
      // On retire tout les espaces et retour a la ligne pour une comparaison plus facile.
      expect(jsonString.replaceAll(RegExp(r'\s'), ''), '{"isSet":false,"id":1,"name":"TestMedia","uuid":"${media.uuid}"}');
    });

    test('fromJson() creates Media object from JSON', () {
      final json = {
        'id': 2,
        'name': 'From JSON',
        'uuid': 'test-uuid',
      };
      final newMedia = Media.fromJson(json);
      expect(newMedia.id, 2);
      expect(newMedia.name, 'From JSON');
      expect(newMedia.uuid, 'test-uuid');
    });
  });
}