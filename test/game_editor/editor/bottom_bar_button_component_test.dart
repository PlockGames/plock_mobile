import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_component.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Initialiser le binding de test

  group('BottomBarButtonComponent Tests', () {
    test('component initializes with correct position and priority', () {
      final position = Vector2(50, 75);
      final component = BottomBarbuttonComponent('test.svg', position);

      expect(component.position, position);
      expect(component.priority, 10000);
    });


    test('tapAction is called when onTapUp is triggered', () async {
      bool tapActionCalled = false;
      final component = BottomBarbuttonComponent(
        'test.svg',
        Vector2.zero(),
        tapAction: () => tapActionCalled = true,
      );
      final game = FlameGame();
      await game.add(component);

      final tapEvent = TapUpEvent(
        1,
        game,
        TapUpDetails(
          kind: PointerDeviceKind.touch,
          localPosition: Offset.zero,
        ),
      );

      component.onTapUp(tapEvent);
      expect(tapActionCalled, true);
    });

    test('onTapUp returns true', () async {
      final component = BottomBarbuttonComponent('test.svg', Vector2.zero());
      final game = FlameGame();
      await game.add(component);

      final tapEvent = TapUpEvent(
        1,
        game,
        TapUpDetails(
          kind: PointerDeviceKind.touch,
          localPosition: Offset.zero,
        ),
      );

      final result = component.onTapUp(tapEvent);
      expect(result, true);
    });
  });
}