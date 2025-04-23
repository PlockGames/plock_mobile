import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Canvas;
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_button_canvas_component.dart';
import 'package:flame/events.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';

void main() {
  group('BottomBarButtonCanvasComponent Tests', () {
    test('svgPathes contains correct keys', () {
      final component = BottomBarButtonCanvasComponent(
          Vector2(0, 0),
          getCanvas: () => EditorCanvas.scene
      );

      expect(component.svgPathes.containsKey(EditorCanvas.scene), true);
      expect(component.svgPathes.containsKey(EditorCanvas.ui), true);
    });

    test('svgPathes contains correct paths', () {
      final component = BottomBarButtonCanvasComponent(
          Vector2(0, 0),
          getCanvas: () => EditorCanvas.scene
      );

      expect(component.svgPathes[EditorCanvas.scene], 'svg/scene.svg');
      expect(component.svgPathes[EditorCanvas.ui], 'svg/ui.svg');
    });

    test('component initializes with correct position', () {
      final testPosition = Vector2(50, 75);
      final component = BottomBarButtonCanvasComponent(
          testPosition,
          getCanvas: () => EditorCanvas.scene
      );

      expect(component.position, testPosition);
    });

    test('component initializes with correct priority', () {
      final component = BottomBarButtonCanvasComponent(
          Vector2(0, 0),
          getCanvas: () => EditorCanvas.scene
      );

      expect(component.priority, 10000);
    });

    test('tapAction is called when onTapUp is triggered', () {
      bool tapActionCalled = false;
      final component = BottomBarButtonCanvasComponent(
          Vector2(0, 0),
          getCanvas: () => EditorCanvas.scene,
          tapAction: () => tapActionCalled = true
      );

      final tapEvent = TapUpEvent(
        1,
        MockGame(), // Passer une instance de Game
        TapUpDetails(
          kind: PointerDeviceKind.touch,
          localPosition: Offset(10, 10),
        ),
      );

      component.onTapUp(tapEvent);
      expect(tapActionCalled, true);
    });

    test('onTapUp returns true', () {
      final component = BottomBarButtonCanvasComponent(
          Vector2(0, 0),
          getCanvas: () => EditorCanvas.scene
      );

      final tapEvent = TapUpEvent(
        1,
        MockGame(), // Passer une instance de Game
        TapUpDetails(
          kind: PointerDeviceKind.touch,
          localPosition: Offset(10, 10),
        ),
      );

      expect(component.onTapUp(tapEvent), true);
    });

  });
}

// Classe pour mocker Canvas pour les tests
class MockCanvas implements Canvas {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock Game class
class MockGame extends Game {
  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {}
}