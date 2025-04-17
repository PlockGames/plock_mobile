import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_fields/component_field_list.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_types/component_sprite.dart';

import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_sprite.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';

import 'package:flame/components.dart';

void main() {
  group('ComponentSprite', () {
    late ComponentSprite componentSprite;

    setUp(() {
      componentSprite = ComponentSprite();
    });

    test('should properly implement ComponentType interface', () {
      expect(componentSprite, isA<ComponentType>());
      expect(componentSprite.type, equals('ComponentSprite'));
      expect(componentSprite.name, equals('Sprite'));
      expect(componentSprite.instance(), isA<ComponentSprite>());
    });

    test('should initialize with correct default fields', () {
      expect(componentSprite.fields['size'], isA<ComponentFieldNumber>());
      expect(componentSprite.fields['size']!.value, equals(1.0));

      expect(componentSprite.fields['current'], isA<ComponentFieldText>());
      expect(componentSprite.fields['current']!.value, equals(''));

      expect(componentSprite.fields['animator'], isA<ComponentFieldSprite>());
      expect(componentSprite.fields['animator']!.value, isEmpty);
    });

    test('should create an instance with copied field values', () {
      ComponentSprite originalSprite = ComponentSprite();
      originalSprite.fields['size']!.value = 2.5;
      originalSprite.fields['current']!.value = 'test_animation';

      ComponentType newInstance = originalSprite.instance();

      expect(newInstance, isA<ComponentSprite>());
      expect(newInstance.fields['size']!.value, equals(2.5));
      expect(newInstance.fields['current']!.value, equals('test_animation'));
    });

    test('getDisplayComponent should handle empty animator list', () {
      var displayComponents = componentSprite.getDisplayComponent(
          [], // empty medias list
          null, // onTapeUpCallback
          null, // onDragStartCallback
          null, // onDragUpdateCallback
          null, // onDragEndCallback
          null  // onDragCancelCallback
      );

      expect(displayComponents.display, isNull);
      expect(displayComponents.select, isNull);
    });

    test('getGameDisplayComponent should handle empty animator list', () {
      var gameComponent = componentSprite.getGameDisplayComponent(
          [], // empty medias list
          null, // onTapeUpCallback
          null, // onDragStartCallback
          null, // onDragUpdateCallback
          null, // onDragEndCallback
          null  // onDragCancelCallback
      );

      expect(gameComponent, isNull);
    });


  });
}

