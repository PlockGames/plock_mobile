import 'package:flutter_test/flutter_test.dart';

enum EditorMode {
  edit,
  move,
}

void main() {
  group('EditorMode Enum', () {
    test('EditorMode.edit should have the correct value', () {
      expect(EditorMode.edit, equals(EditorMode.edit));
    });

    test('EditorMode.move should have the correct value', () {
      expect(EditorMode.move, equals(EditorMode.move));
    });

    test('EditorMode.values should contain both edit and move', () {
      expect(EditorMode.values, contains(EditorMode.edit));
      expect(EditorMode.values, contains(EditorMode.move));
      expect(EditorMode.values.length, equals(2));
    });

    test('EditorMode.edit.index should be 0', () {
      expect(EditorMode.edit.index, equals(0));
    });

    test('EditorMode.move.index should be 1', () {
      expect(EditorMode.move.index, equals(1));
    });

    test('EditorMode.values[0] should be edit', () {
      expect(EditorMode.values[0], equals(EditorMode.edit));
    });

    test('EditorMode.values[1] should be move', () {
      expect(EditorMode.values[1], equals(EditorMode.move));
    });

    test('EditorMode.edit.toString() should return "EditorMode.edit"', () {
      expect(EditorMode.edit.toString(), equals('EditorMode.edit'));
    });

    test('EditorMode.move.toString() should return "EditorMode.move"', () {
      expect(EditorMode.move.toString(), equals('EditorMode.move'));
    });
  });
}