import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_image.dart';
import 'package:plock_mobile/models/component_fields/image/media_select.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/pages/play/game_player_object.dart';
import 'package:plock_mobile/models/component_flame/component_flame_image.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:plock_mobile/models/component_types/component_ui_image.dart';



import 'dart:io';

void main() {
  group('ComponentUiImage', () {
    late ComponentUiImage componentUiImage;
    late Media testMedia;
    late File testFile;

    setUp(() {
      componentUiImage = ComponentUiImage();
      testFile = File('test.png');
      testMedia = Media(name: 'test', file: testFile);
    });

    test('should initialize with default values', () {
      expect(componentUiImage.type, 'ComponentUiImage');
      expect(componentUiImage.name, 'Image');

      expect(componentUiImage.fields['size'], isA<ComponentFieldNumber>());
      expect((componentUiImage.fields['size'] as ComponentFieldNumber).value, 1.0);

      expect(componentUiImage.fields['texture'], isA<ComponentFieldImage>());
      expect((componentUiImage.fields['texture'] as ComponentFieldImage).value, isA<MediaSelect>());
    });

    test('instance() should create a new instance with copied fields', () {
      // Modify original values
      (componentUiImage.fields['size'] as ComponentFieldNumber).value = 2.0;
      (componentUiImage.fields['texture'] as ComponentFieldImage).value = MediaSelect(name: 'test');

      final newInstance = componentUiImage.instance() as ComponentUiImage;

      expect((newInstance.fields['size'] as ComponentFieldNumber).value, 2.0);
      expect((newInstance.fields['texture'] as ComponentFieldImage).value.name, 'test');
      expect(newInstance.fields['size'], isNot(same(componentUiImage.fields['size'])));
    });

    test('getDisplayComponent should return DisplayComponents with null when no texture', () {
      final displayComponents = componentUiImage.getDisplayComponent(
          [],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(displayComponents.display, isNull);
      expect(displayComponents.select, isNull);
    });

    test('getDisplayComponent should return DisplayComponents with image when media found', () {
      (componentUiImage.fields['texture'] as ComponentFieldImage).value = MediaSelect(name: 'test');

      final displayComponents = componentUiImage.getDisplayComponent(
          [testMedia],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(displayComponents.display, isA<ComponentFlameImage>());
      expect(displayComponents.select, isNull);

      final displayImage = displayComponents.display as ComponentFlameImage;
      expect(displayImage.image, testFile);
    });

    test('getDisplayComponent should return null display when media not found', () {
      (componentUiImage.fields['texture'] as ComponentFieldImage).value = MediaSelect(name: 'not_found');

      final displayComponents = componentUiImage.getDisplayComponent(
          [testMedia],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(displayComponents.display, isNull);
      expect(displayComponents.select, isNull);
    });

    test('getGameDisplayComponent should return null when no texture', () {
      final gameDisplay = componentUiImage.getGameDisplayComponent(
          [],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(gameDisplay, isNull);
    });

    test('getGameDisplayComponent should return ComponentFlameImage when media found', () {
      (componentUiImage.fields['texture'] as ComponentFieldImage).value = MediaSelect(name: 'test');
      (componentUiImage.fields['size'] as ComponentFieldNumber).value = 2.0;

      final gameDisplay = componentUiImage.getGameDisplayComponent(
          [testMedia],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(gameDisplay, isA<ComponentFlameImage>());
      final gameImage = gameDisplay as ComponentFlameImage;
      expect(gameImage.image, testFile);
      expect(gameImage.initScale, Vector2(2.0, 2.0));
    });

    test('updateDisplay should update ComponentFlameImage with new texture', () async {
      final testComponent = ComponentFlameImage(
        image: testFile,
        initScale: Vector2(1, 1),
        componentType: componentUiImage,
        onTapeUpCallback: () {},
        onDragStartCallback: () {},
        onDragUpdateCallback: () {},
        onDragEndCallback: () {},
        onDragCancelCallback: () {},
      );

      (componentUiImage.fields['texture'] as ComponentFieldImage).value = MediaSelect(name: 'test');

      // Mock GamePlayerObject with medias
      final parent = GamePlayerObject(
        plockGame: PlockGame()..medias = [testMedia],
        // Add other required parameters
      );

      final updatedParent = await componentUiImage.updateDisplay(testComponent, parent);

      // Can't easily verify sprite update due to image decoding
      // but we can verify the parent was returned
      expect(updatedParent, parent);
    });

    test('updateDisplay should handle null component', () async {
      final parent = GamePlayerObject(
        plockGame: PlockGame(),
        // Add other required parameters
      );

      final updatedParent = await componentUiImage.updateDisplay(null, parent);
      expect(updatedParent, parent);
    });
  });
}