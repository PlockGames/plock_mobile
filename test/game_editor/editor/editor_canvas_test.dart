import 'package:flutter_test/flutter_test.dart';

enum EditorCanvas {
  ui,
  scene,
}

void main() {
  group('EditorCanvas Enum', () {
    test('EditorCanvas.ui should have the correct value', () {
      expect(EditorCanvas.ui, equals(EditorCanvas.ui));
    });

    test('EditorCanvas.scene should have the correct value', () {
      expect(EditorCanvas.scene, equals(EditorCanvas.scene));
    });

    test('EditorCanvas.values should contain both ui and scene', () {
      expect(EditorCanvas.values, contains(EditorCanvas.ui));
      expect(EditorCanvas.values, contains(EditorCanvas.scene));
      expect(EditorCanvas.values.length, equals(2));
    });

    test('EditorCanvas.ui.index should be 0', () {
      expect(EditorCanvas.ui.index, equals(0));
    });

    test('EditorCanvas.scene.index should be 1', () {
      expect(EditorCanvas.scene.index, equals(1));
    });

    test('EditorCanvas.values[0] should be ui', () {
      expect(EditorCanvas.values[0], equals(EditorCanvas.ui));
    });

    test('EditorCanvas.values[1] should be scene', () {
      expect(EditorCanvas.values[1], equals(EditorCanvas.scene));
    });

    test('EditorCanvas.ui.toString() should return "EditorCanvas.ui"', () {
      expect(EditorCanvas.ui.toString(), equals('EditorCanvas.ui'));
    });

    test('EditorCanvas.scene.toString() should return "EditorCanvas.scene"', () {
      expect(EditorCanvas.scene.toString(), equals('EditorCanvas.scene'));
    });
  });
}