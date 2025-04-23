import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_types/component_rect.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_color.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/component_flame/component_flame_rect.dart';
import 'dart:ui';

void main() {
  group('ComponentRect', () {
    late ComponentRect componentRect;

    setUp(() {
      componentRect = ComponentRect();
    });

    test('should initialize with default values', () {
      expect(componentRect.type, 'ComponentRect');
      expect(componentRect.name, 'Rectangle');

      expect(componentRect.fields['width'], isA<ComponentFieldNumber>());
      expect((componentRect.fields['width'] as ComponentFieldNumber).value, 1.0);

      expect(componentRect.fields['height'], isA<ComponentFieldNumber>());
      expect((componentRect.fields['height'] as ComponentFieldNumber).value, 1.0);

      expect(componentRect.fields['color'], isA<ComponentFieldColour>());
      expect((componentRect.fields['color'] as ComponentFieldColour).value, const Color(0xffffffff));
    });

    test('instance() should create a new instance with copied fields', () {
      // Modify original values
      (componentRect.fields['width'] as ComponentFieldNumber).value = 2.0;
      (componentRect.fields['height'] as ComponentFieldNumber).value = 3.0;
      (componentRect.fields['color'] as ComponentFieldColour).value = const Color(0xff000000);

      final newInstance = componentRect.instance() as ComponentRect;

      expect((newInstance.fields['width'] as ComponentFieldNumber).value, 2.0);
      expect((newInstance.fields['height'] as ComponentFieldNumber).value, 3.0);
      expect((newInstance.fields['color'] as ComponentFieldColour).value, const Color(0xff000000));
      expect(newInstance.fields['width'], isNot(same(componentRect.fields['width'])));
    });

    test('getDisplayComponent should return DisplayComponents with correct components', () {
      (componentRect.fields['width'] as ComponentFieldNumber).value = 50.0;
      (componentRect.fields['height'] as ComponentFieldNumber).value = 30.0;
      (componentRect.fields['color'] as ComponentFieldColour).value = const Color(0xff123456);

      final displayComponents = componentRect.getDisplayComponent(
          [],
              () {}, () {}, () {}, () {}, () {}
      );

      expect(displayComponents, isA<DisplayComponents>());

      final displayRect = displayComponents.display as ComponentFlameRect;
      expect(displayRect.size, Vector2(50.0, 30.0));
      expect(displayRect.color, const Color(0xff123456));

      final selectRect = displayComponents.select as RectangleComponent;
      expect(selectRect.size, Vector2(50.0 * 20, 30.0 * 20));
      expect(selectRect.scale, Vector2(0.05, 0.05));
    });

    test('getGameDisplayComponent should return ComponentFlameRect with correct properties', () {
      (componentRect.fields['width'] as ComponentFieldNumber).value = 100.0;
      (componentRect.fields['height'] as ComponentFieldNumber).value = 60.0;
      (componentRect.fields['color'] as ComponentFieldColour).value = const Color(0xff654321);

      final gameDisplay = componentRect.getGameDisplayComponent(
          [], () {}, () {}, () {}, () {}, () {}
      );

      final gameRect = gameDisplay as ComponentFlameRect;
      expect(gameRect.size, Vector2(100.0, 60.0));
      expect(gameRect.color, const Color(0xff654321));
      expect(gameRect.position, Vector2(0, 0));
    });

    test('updateDisplay should update ComponentFlameRect properties', () async {
      final testComponent = ComponentFlameRect(
        size: Vector2(35, 35),
        color: const Color(0xff112233),
        position: Vector2.zero(),
        onTapeUpCallback: () {},
        onDragStartCallback: () {},
        onDragUpdateCallback: () {},
        onDragEndCallback: () {},
        onDragCancelCallback: () {},
        componentType: componentRect,
      );

      (componentRect.fields['width'] as ComponentFieldNumber).value = 25.0;
      (componentRect.fields['height'] as ComponentFieldNumber).value = 35.0;
      (componentRect.fields['color'] as ComponentFieldColour).value = const Color(0xff112233);


      expect(testComponent.width, 35.0);
      expect(testComponent.height, 35.0);
      expect(testComponent.paint.color, const Color(0xff112233));
    });


  });
}