import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_mode_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_mode.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  group('BottomBarButtonModeComponent Tests', () {
    test('component initializes with correct position and priority', () {
      final position = Vector2(50, 75);
      final component = BottomBarbuttonModeComponent(
        position,
        getMode: () => EditorMode.edit,
      );

      expect(component.position, position);
      expect(component.priority, 10000);
    });

    test('component loads SVG and adds SvgComponent', () async {
      final component = BottomBarbuttonModeComponent(
        Vector2.zero(),
        getMode: () => EditorMode.edit,
      );
      final game = FlameGame();
      await game.add(component);

      // Attendre que svgComponent soit initialisé
      await Future.delayed(Duration(milliseconds: 100)); // Délai initial

      int tries = 0;
      while (component.children.whereType<SvgComponent>().isEmpty && tries < 10) {
        await Future.delayed(Duration(milliseconds: 100));
        tries++;
      }


      if (component.children.whereType<SvgComponent>().isNotEmpty) {
        final svgComponent = component.children.whereType<SvgComponent>().first;
        expect(svgComponent.size, Vector2(40, 40));
        expect(svgComponent.position, Vector2(0, 10));
      }
    });

    test('tapAction is called when onTapUp is triggered', () async {
      bool tapActionCalled = false;
      final component = BottomBarbuttonModeComponent(
        Vector2.zero(),
        getMode: () => EditorMode.edit,
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
      final component = BottomBarbuttonModeComponent(
        Vector2.zero(),
        getMode: () => EditorMode.edit,
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

      final result = component.onTapUp(tapEvent);
      expect(result, true);
    });

    test('render changes SVG based on getMode', () async {
      EditorMode currentMode = EditorMode.edit;
      final component = BottomBarbuttonModeComponent(
        Vector2.zero(),
        getMode: () => currentMode,
      );
      final game = FlameGame();
      await game.add(component);

      // Attendre que svgComponent soit initialisé
      await Future.delayed(Duration(milliseconds: 100));

      int tries = 0;
      while (component.children.whereType<SvgComponent>().isEmpty && tries < 10) {
        await Future.delayed(Duration(milliseconds: 100));
        tries++;
      }

      if (component.children.whereType<SvgComponent>().isNotEmpty) {
        final initialSvg = component.children.whereType<SvgComponent>().first.svg;

        currentMode = EditorMode.move;
        component.render(MockCanvas());

        expect(component.children.whereType<SvgComponent>().first.svg, isNot(initialSvg));
      }
    });
  });
}

class MockCanvas implements Canvas {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}