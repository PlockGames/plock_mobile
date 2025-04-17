import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';
void main() {
  group('ComponentField', () {
    late ComponentField field;

    setUp(() {
      field = ComponentField();
    });

    test('type returns "Field"', () {
      expect(field.type, 'Field');
    });

    test('onUpdate is initially null', () {
      expect(field.onUpdate, null);
    });

    test('getField returns a Container', () {
      final widget = field.getField('testName', false, [], {});
      expect(widget, isA<Container>());
    });

    test('instance returns a new ComponentField with same onUpdate', () {
      final onUpdateFunction = () {};
      field.onUpdate = onUpdateFunction;
      final newField = field.instance();
      expect(newField.onUpdate, onUpdateFunction);
    });

    test('toJson returns an empty string', () {
      expect(field.toJson(), '');
    });

    test('updateFromJson does nothing by default', () {
      expect(() => field.updateFromJson('test'), returnsNormally);
    });

    test('value getter and setter do nothing by default', () {
      field.value = 'testValue';
      expect(field.value, null);
    });

    test('debugData returns an empty map', () {
      expect(field.debugData, {});
    });
  });
}