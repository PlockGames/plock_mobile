import 'package:plock_mobile/models/component_fields/image/media_select.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlockSpriteAnimation Tests', () {
    test('Should create PlockSpriteAnimation with a name', () {
      final animation = PlockSpriteAnimation(name: 'TestAnimation');

      expect(animation.name, 'TestAnimation');
      expect(animation.images, isEmpty);
      expect(animation.fps, 0.1);
    });

    test('Should correctly convert to JSON', () {
      final animation = PlockSpriteAnimation(name: 'TestAnimation');
      animation.images.add(MediaSelect()..name = 'image1'..index = 0);
      animation.images.add(MediaSelect()..name = 'image2'..index = 1);
      animation.fps = 0.2;

      final json = animation.toJson();

      expect(json, contains('"name": "TestAnimation"'));
      expect(json, contains('"fps": 0.2'));
      expect(json, contains('"name": "image1"'));
      expect(json, contains('"name": "image2"'));
    });

    test('Should correctly parse from JSON', () {
      final json = {
        'name': 'TestAnimation',
        'images': [
          {'name': 'image1', 'index': 0},
          {'name': 'image2', 'index': 1}
        ],
        'fps': 0.2
      };

      final animation = PlockSpriteAnimation.fromJson(json);

      expect(animation.name, 'TestAnimation');
      expect(animation.images.length, 2);
      expect(animation.images[0].name, 'image1');
      expect(animation.images[0].index, 0);
      expect(animation.images[1].name, 'image2');
      expect(animation.images[1].index, 1);
      expect(animation.fps, 0.2);
    });
  });
}
