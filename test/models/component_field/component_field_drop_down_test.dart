import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  group('ComponentFieldDropDown Tests', () {
    test('Should create ComponentFieldDropDown with default values', () {
      final dropdownField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
      );

      expect(dropdownField.type, 'ComponentFieldDropDown');
      expect(dropdownField.value, 'Option 1');
    });

    test('Should update value correctly', () {
      final dropdownField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
      );
      dropdownField.updateValue('Option 2');

      expect(dropdownField.value, 'Option 2');
    });

    test('Should create an instance with the same values', () {
      final originalField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
      );
      final instanceField = originalField.instance();

      expect(instanceField.value, originalField.value);
      // We cannot directly test 'options' as it is private.
    });

    test('Should convert value to JSON correctly', () {
      final dropdownField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
      );
      final json = dropdownField.toJson();

      expect(json, '"Option 1"');
    });

    test('Should update from JSON correctly', () {
      final dropdownField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
      );
      dropdownField.updateFromJson('Option 2');

      expect(dropdownField.value, 'Option 2');
    });
  });
}