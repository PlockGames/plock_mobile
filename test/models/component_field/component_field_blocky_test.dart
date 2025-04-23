import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';

void main() {
  // Ensure Flutter binding is initialized
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('ComponentFieldBlockly Tests', () {
    test('Should create ComponentFieldBlockly with default values', () {
      final blocklyField = ComponentFieldBlockly();

      expect(blocklyField.type, 'ComponentFieldBlocky');
      expect(blocklyField.value[0], '');
      expect(blocklyField.value[1], {
        'blocks': {
          'languageVersion': 0,
          'blocks': [],
        },
      });
    });

    test('Should create ComponentFieldBlockly with custom values', () {
      final customJson = {
        'blocks': {
          'languageVersion': 1,
          'blocks': [{'type': 'custom_block'}],
        },
      };
      final customJs = 'console.log("Hello");';

      final blocklyField = ComponentFieldBlockly(
        value: customJson,
        value_js: customJs,
      );

      expect(blocklyField.value[0], customJs);
      expect(blocklyField.value[1], customJson);
    });

    test('Should create an instance with the same values', () {
      final originalField = ComponentFieldBlockly(
        value: {'blocks': {'languageVersion': 1, 'blocks': []}},
        value_js: 'test code',
      );

      final instanceField = originalField.instance();

      expect(instanceField.value[0], originalField.value[0]);
      expect(instanceField.value[1], originalField.value[1]);
    });

    test('Should convert to JSON correctly', () {
      final blocklyField = ComponentFieldBlockly(
        value_js: 'console.log("Test");',
      );

      final jsonValue = blocklyField.toJson();

      expect(jsonValue, '"console.log(\\"Test\\");"');
    });

    test('Should update from JSON', () {
      final blocklyField = ComponentFieldBlockly();
      final newJsValue = 'alert("Updated");';

      blocklyField.updateFromJson(newJsValue);

      expect(blocklyField.value[0], newJsValue);
    });

    test('Should return debug data', () {
      final blocklyField = ComponentFieldBlockly();

      expect(blocklyField.debugData, isEmpty);
    });
  });
}