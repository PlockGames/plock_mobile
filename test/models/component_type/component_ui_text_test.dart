import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:plock_mobile/models/component_types/component_ui_text.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_color.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/component_flame/component_flame_text.dart';
import 'package:plock_mobile/pages/play/game_player_object.dart';
import 'dart:ui';

void main() {
  group('ComponentUiText', () {
    late ComponentUiText componentUiText;

    setUp(() {
      componentUiText = ComponentUiText();
    });

    test('should initialize with default values', () {
      expect(componentUiText.type, 'ComponentUiText');
      expect(componentUiText.name, 'Text');

      expect(componentUiText.fields['text'], isA<ComponentFieldText>());
      expect((componentUiText.fields['text'] as ComponentFieldText).value, 'Text');

      expect(componentUiText.fields['size'], isA<ComponentFieldNumber>());
      expect((componentUiText.fields['size'] as ComponentFieldNumber).value, 20.0);

      expect(componentUiText.fields['color'], isA<ComponentFieldColour>());
      expect((componentUiText.fields['color'] as ComponentFieldColour).value, const Color(0xffffffff));
    });

    test('instance() should create a deep copy', () {
      // Modify original values
      (componentUiText.fields['text'] as ComponentFieldText).value = 'New Text';
      (componentUiText.fields['size'] as ComponentFieldNumber).value = 30.0;
      (componentUiText.fields['color'] as ComponentFieldColour).value = const Color(0xff000000);

      final copy = componentUiText.instance() as ComponentUiText;

      // Verify copied values
      expect((copy.fields['text'] as ComponentFieldText).value, 'New Text');
      expect((copy.fields['size'] as ComponentFieldNumber).value, 30.0);
      expect((copy.fields['color'] as ComponentFieldColour).value, const Color(0xff000000));

      // Verify it's a deep copy
      expect(copy.fields['text'], isNot(same(componentUiText.fields['text'])));
    });

    test('getDisplayComponent should return DisplayComponents with text', () {
      final displayComponents = componentUiText.getDisplayComponent(
          [],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(displayComponents.display, isA<ComponentFlameText>());
      expect(displayComponents.select, isA<RectangleComponent>());

      final textComponent = displayComponents.display as ComponentFlameText;
      expect(textComponent.text, 'Text');
      expect(textComponent.fontSize, 20.0);
    });

    test('getGameDisplayComponent should return TextComponent', () {
      (componentUiText.fields['text'] as ComponentFieldText).value = 'Game Text';
      (componentUiText.fields['size'] as ComponentFieldNumber).value = 25.0;

      final gameDisplay = componentUiText.getGameDisplayComponent(
          [],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(gameDisplay, isA<ComponentFlameText>());
      final textComponent = gameDisplay as ComponentFlameText;
      expect(textComponent.text, 'Game Text');
      expect(textComponent.fontSize, 25.0);
    });

  });
}