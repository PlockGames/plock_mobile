import 'dart:ui';
import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_flame/component_flame_circle.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/component_fields/image/part_image.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plock_mobile/models/component_fields/component_field_color.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/pages/play/game_player_object.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_types/component_circle.dart';

// Simple mock classes for testing
class TestGamePlayerObject implements GamePlayerObject {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// Simple mock Media class
class TestMedia implements Media {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  group('ComponentCircle Tests', () {
    late ComponentCircle componentCircle;

    // Dummy callback functions for testing
    bool onTapUpCalled = false;
    bool onDragStartCalled = false;
    bool onDragUpdateCalled = false;
    bool onDragEndCalled = false;
    bool onDragCancelCalled = false;

    setUp(() {
      componentCircle = ComponentCircle();

      // Reset callback flags
      onTapUpCalled = false;
      onDragStartCalled = false;
      onDragUpdateCalled = false;
      onDragEndCalled = false;
      onDragCancelCalled = false;
    });

    test('Initialization', () {
      expect(componentCircle.type, 'ComponentCircle');
      expect(componentCircle.name, 'Circle');

      // Check default fields
      expect(componentCircle.fields['radius'], isNotNull);
      expect(componentCircle.fields['color'], isNotNull);
      expect(componentCircle.fields['radius']!.value, 1.0);
      expect(componentCircle.fields['color']!.value, Color(0xffffffff));
    });

    test('Instance method creates a new ComponentCircle with copied fields', () {
      componentCircle.fields['radius']!.value = 5.0;
      componentCircle.fields['color']!.value = Color(0xff000000);

      ComponentType newInstance = componentCircle.instance();

      expect(newInstance, isA<ComponentCircle>());
      expect(newInstance.fields['radius']!.value, 5.0);
      expect(newInstance.fields['color']!.value, Color(0xff000000));
      expect(newInstance, isNot(same(componentCircle)));
    });

    test('getDisplayComponent creates correct DisplayComponents', () {
      // Dummy callback functions
      bool tapResult = false;
      final onTapUpCallback = (info) {
        onTapUpCalled = true;
        return tapResult;
      };
      final onDragStartCallback = (event) {
        onDragStartCalled = true;
      };
      final onDragUpdateCallback = (event) {
        onDragUpdateCalled = true;
      };
      final onDragEndCallback = (event) {
        onDragEndCalled = true;
      };
      final onDragCancelCallback = (event) {
        onDragCancelCalled = true;
      };

      // Prepare media list
      final medias = <Media>[TestMedia()];

      // Call getDisplayComponent
      final displayComponents = componentCircle.getDisplayComponent(
          medias,
          onTapUpCallback,
          onDragStartCallback,
          onDragUpdateCallback,
          onDragEndCallback,
          onDragCancelCallback
      );

      // Verify display component
      expect(displayComponents, isA<DisplayComponents>());
      expect(displayComponents.display, isA<ComponentFlameCircle>());
      expect(displayComponents.select, isA<CircleComponent>());

      // Check display component properties
      final display = displayComponents.display as ComponentFlameCircle;
      expect(display.radius, 1.0);
      expect(display.paint.color, Color(0xffffffff));
      expect(display.position, Vector2(0, 0));

      // Verify that the select component is a child
      expect(display.children.length, 1);
      expect(display.children.first, displayComponents.select);
    });

    test('getGameDisplayComponent creates correct ComponentFlameCircle', () {
      // Dummy callback functions
      final onTapUpCallback = (info) => true;
      final onDragStartCallback = (event) {};
      final onDragUpdateCallback = (event) {};
      final onDragEndCallback = (event) {};
      final onDragCancelCallback = (event) {};

      // Prepare media list
      final medias = <Media>[TestMedia()];

      // Call getGameDisplayComponent
      final gameComponent = componentCircle.getGameDisplayComponent(
          medias,
          onTapUpCallback,
          onDragStartCallback,
          onDragUpdateCallback,
          onDragEndCallback,
          onDragCancelCallback
      );

      // Verify game component
      expect(gameComponent, isA<ComponentFlameCircle>());

      final flameCircle = gameComponent as ComponentFlameCircle;
      expect(flameCircle.radius, 1.0);
      expect(flameCircle.paint.color, Color(0xffffffff));
      expect(flameCircle.position, Vector2(0, 0));
    });

    test('updateDisplay updates ComponentFlameCircle properties', () async {
      // Create a ComponentFlameCircle
      final flameCircle = ComponentFlameCircle(
          radius: 2.0,
          position: Vector2(0, 0),
          color: Color(0xff000000),
          onTapeUpCallback: (info) => true,
          onDragCancelCallback: (event) {},
          onDragEndCallback: (event) {},
          onDragStartCallback: (event) {},
          onDragUpdateCallback: (event) {},
          componentType: componentCircle
      );

      // Update field values
      componentCircle.fields['radius']!.value = 5.0;
      componentCircle.fields['color']!.value = Color(0xffff0000);

      // Prepare parent
      final parent = TestGamePlayerObject();

      // Call updateDisplay
      final result = await componentCircle.updateDisplay(flameCircle, parent);

      // Verify updates
      expect(flameCircle.radius, 5.0);
      expect(flameCircle.paint.color, Color(0xffff0000));
      expect(result, parent);
    });

    test('updateDisplay does nothing for non-ComponentFlameCircle', () async {
      // Prepare non-matching component
      final nonMatchingComponent = CircleComponent();
      final parent = TestGamePlayerObject();

      // Call updateDisplay
      final result = await componentCircle.updateDisplay(nonMatchingComponent, parent);

      // Verify no changes and returns parent
      expect(result, parent);
    });
  });
}