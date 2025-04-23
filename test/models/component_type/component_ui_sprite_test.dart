import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_fields/component_field_sprite.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/component_flame/component_flame_sprite.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/pages/play/game_player_object.dart';
import 'package:plock_mobile/pages/play/game_player_ui_object.dart';
import 'package:plock_mobile/models/component_types/component_ui_sprite.dart';
import 'package:flutter/foundation.dart'; // Import VoidCallback
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/component_fields/image/media_select.dart'; // Import MediaSelect

void main() {
  group('ComponentUiSprite', () {
    late ComponentUiSprite componentUiSprite;
    late List<Media> mockMedias;
    VoidCallback mockCallback = () {};

    setUp(() {
      componentUiSprite = ComponentUiSprite();
      mockMedias = []; // Initialize with an empty list or mock data if needed
    });

    test('type getter returns "ComponentUiSprite"', () {
      expect(componentUiSprite.type, 'ComponentUiSprite');
    });

    test('name getter returns "Sprite"', () {
      expect(componentUiSprite.name, 'Sprite');
    });

    test('instance() creates a new ComponentUiSprite with the same fields', () {
      final newInstance = componentUiSprite.instance();
      expect(newInstance, isA<ComponentUiSprite>());
      expect(newInstance.fields.keys, componentUiSprite.fields.keys);
      expect(newInstance.fields['size']!.value, 100.0);
      expect(newInstance.fields['current']!.value, '');
      expect(newInstance.fields['animator']!.value, isEmpty);
    });

    group('getDisplayComponent()', () {
      test('returns DisplayComponents with null display and select if animator is empty', () {
        final displayComponents = componentUiSprite.getDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponents.display, isNull);
        expect(displayComponents.select, isNull);
      });

      test('returns DisplayComponents with null display and select if first animation has empty images', () {
        final mockAnimationEmpty = PlockSpriteAnimation(name: 'anim1');
        componentUiSprite.fields['animator']!.value = [mockAnimationEmpty];
        final displayComponents = componentUiSprite.getDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponents.display, isNull);
        expect(displayComponents.select, isNull);
      });

      test('returns DisplayComponents with ComponentFlameSprite using the first animation if current is empty', () {
        final mockAnimation = PlockSpriteAnimation(name: 'anim1');
        mockAnimation.images.add(MediaSelect()..name = 'image1.png'..index = 0);
        componentUiSprite.fields['animator']!.value = [mockAnimation];
        final displayComponents = componentUiSprite.getDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponents.display, isA<ComponentFlameSprite>());
        expect((displayComponents.display as ComponentFlameSprite).animation, mockAnimation);
        expect((displayComponents.display as ComponentFlameSprite).initScale, Vector2(100.0, 100.0));
        expect((displayComponents.display as ComponentFlameSprite).componentType, componentUiSprite);
        expect(displayComponents.select, isNull);
      });

      test('returns DisplayComponents with ComponentFlameSprite using the animation with the current name', () {
        final mockAnimation1 = PlockSpriteAnimation(name: 'anim1');
        mockAnimation1.images.add(MediaSelect()..name = 'image1.png'..index = 0);
        final mockAnimation2 = PlockSpriteAnimation(name: 'anim2');
        mockAnimation2.images.add(MediaSelect()..name = 'image2.png'..index = 1);
        componentUiSprite.fields['animator']!.value = [mockAnimation1, mockAnimation2];
        componentUiSprite.fields['current']!.value = 'anim2';
        final displayComponents = componentUiSprite.getDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponents.display, isA<ComponentFlameSprite>());
        expect((displayComponents.display as ComponentFlameSprite).animation, mockAnimation2);
        expect(displayComponents.select, isNull);
      });

      test('returns DisplayComponents with ComponentFlameSprite using the first animation if current name is not found', () {
        final mockAnimation1 = PlockSpriteAnimation(name: 'anim1');
        mockAnimation1.images.add(MediaSelect()..name = 'image1.png'..index = 0);
        final mockAnimation2 = PlockSpriteAnimation(name: 'anim2');
        mockAnimation2.images.add(MediaSelect()..name = 'image2.png'..index = 1);
        componentUiSprite.fields['animator']!.value = [mockAnimation1, mockAnimation2];
        componentUiSprite.fields['current']!.value = 'anim3';
        final displayComponents = componentUiSprite.getDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponents.display, isA<ComponentFlameSprite>());
        expect((displayComponents.display as ComponentFlameSprite).animation, mockAnimation1);
        expect(displayComponents.select, isNull);
      });
    });

    group('getGameDisplayComponent()', () {
      test('returns null if animator is empty', () {
        final displayComponent = componentUiSprite.getGameDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponent, isNull);
      });

      test('returns ComponentFlameSprite using the first animation if current is empty', () {
        final mockAnimation = PlockSpriteAnimation(name: 'anim1');
        mockAnimation.images.add(MediaSelect()..name = 'image1.png'..index = 0);
        componentUiSprite.fields['animator']!.value = [mockAnimation];
        final displayComponent = componentUiSprite.getGameDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponent, isA<ComponentFlameSprite>());
        expect((displayComponent as ComponentFlameSprite).animation, mockAnimation);
        expect((displayComponent).initScale, Vector2(100.0, 100.0));
        expect((displayComponent).componentType, componentUiSprite);
      });

      test('returns ComponentFlameSprite using the animation with the current name', () {
        final mockAnimation1 = PlockSpriteAnimation(name: 'anim1');
        mockAnimation1.images.add(MediaSelect()..name = 'image1.png'..index = 0);
        final mockAnimation2 = PlockSpriteAnimation(name: 'anim2');
        mockAnimation2.images.add(MediaSelect()..name = 'image2.png'..index = 1);
        componentUiSprite.fields['animator']!.value = [mockAnimation1, mockAnimation2];
        componentUiSprite.fields['current']!.value = 'anim2';
        final displayComponent = componentUiSprite.getGameDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponent, isA<ComponentFlameSprite>());
        expect((displayComponent as ComponentFlameSprite).animation, mockAnimation2);
      });

      test('returns ComponentFlameSprite using the first animation if current name is not found', () {
        final mockAnimation1 = PlockSpriteAnimation(name: 'anim1');
        mockAnimation1.images.add(MediaSelect()..name = 'image1.png'..index = 0);
        final mockAnimation2 = PlockSpriteAnimation(name: 'anim2');
        mockAnimation2.images.add(MediaSelect()..name = 'image2.png'..index = 1);
        componentUiSprite.fields['animator']!.value = [mockAnimation1, mockAnimation2];
        componentUiSprite.fields['current']!.value = 'anim3';
        final displayComponent = componentUiSprite.getGameDisplayComponent(
          mockMedias,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
          mockCallback,
        );
        expect(displayComponent, isA<ComponentFlameSprite>());
        expect((displayComponent as ComponentFlameSprite).animation, mockAnimation1);
      });
    });
  });
}