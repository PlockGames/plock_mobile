import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:plock_mobile/models/component_types/component_circle.dart';
import 'package:plock_mobile/models/component_flame/component_flame_circle.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'dart:ui';

import 'package:plock_mobile/pages/play/game_player_object.dart';
import 'package:mockito/mockito.dart';

class MockGamePlayerObject extends Mock implements GamePlayerObject {}

void main() {
  group('ComponentCircle Tests', () {
    test('should create an instance with default values', () {
      final component = ComponentCircle();

      expect(component.type, 'ComponentCircle');
      expect(component.name, 'Circle');
      expect(component.fields.containsKey('radius'), isTrue);
      expect(component.fields.containsKey('color'), isTrue);
      expect(component.fields['radius']!.value, 1.0); // Updated expectation to match the class
      expect(component.fields['color']!.value, const Color(0xffffffff));
    });

    test('should create a new instance with same values', () {
      final original = ComponentCircle();
      final newInstance = original.instance() as ComponentCircle;

      expect(newInstance.fields['radius']!.value, original.fields['radius']!.value);
      expect(newInstance.fields['color']!.value, original.fields['color']!.value);
      expect(newInstance != original, isTrue); // Vérifie que c'est bien une nouvelle instance
    });

    test('should return a valid DisplayComponents', () {
      final component = ComponentCircle();
      final displayComponent = component.getDisplayComponent(
          [],
              () {},
              (details) {},
              (details) {},
              (details) {},
              () {}
      );

      expect(displayComponent, isA<DisplayComponents>());
      expect(displayComponent.display, isA<ComponentFlameCircle>());
      expect(displayComponent.select, isA<CircleComponent>());
    });

    test('should update display correctly', () {
      final gameObject = GameObject(id: 0, name: 'object');
      final Game game = Game(name: 'game');
      final mockGamePlayerObject = MockGamePlayerObject(); // Using a mock
      final component = ComponentCircle();
      final displayComponent = component.getGameDisplayComponent(
          [],
              () {},
              (details) {},
              (details) {},
              (details) {},
              () {}
      ) as ComponentFlameCircle;

      component.fields['radius']!.value = 30.0;
      component.fields['color']!.value = const Color(0xff0000ff);
      component.updateDisplay(displayComponent, mockGamePlayerObject);

      expect(displayComponent.radius, 30.0);
      expect(displayComponent.paint.color, const Color(0xff0000ff));
    });
  });
}