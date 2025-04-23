import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for Container

void main() {
  group('ComponentField', () {
    test('initialization with default values', () {
      final field = ComponentField();
      expect(field.type, 'Field');
      expect(field.onUpdate, null);
    });

    test('instance() creates a copy', () {
      void testUpdate() {}
      final field = ComponentField(onUpdate: testUpdate);
      final copy = field.instance();

      expect(copy.type, 'Field');
      expect(copy.onUpdate, testUpdate);
    });

    test('toJson() returns empty string by default', () {
      final field = ComponentField();
      expect(field.toJson(), '');
    });

    test('updateFromJson() does nothing by default', () {
      final field = ComponentField();
      field.updateFromJson(10);
      expect(field.value, null); // Value is still null
    });

    test('getField() returns a Container widget', () {
      final field = ComponentField();
      final widget = field.getField('testField', false, [], {});
      expect(widget, isA<Container>());
    });

    test('value getter and setter do nothing by default', () {
      final field = ComponentField();
      field.value = 10;
      expect(field.value, null);
    });

    test('debugData getter returns empty map by default', () {
      final field = ComponentField();
      expect(field.debugData, {});
    });
  });
}