import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:flutter_blockly_plus/flutter_blockly_plus.dart' as BlockyPlus;
import 'package:mockito/mockito.dart';

// Create a Mock for the ComponentFieldBlockly class
class MockComponentFieldBlockly extends Mock implements ComponentFieldBlockly {}

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
      expect(blocklyField.debugData, isEmpty);
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
      expect(blocklyField.debugData, isEmpty);
    });

    test('Should create an instance with the same values', () {
      final originalField = ComponentFieldBlockly(
        value: {'blocks': {'languageVersion': 1, 'blocks': []}},
        value_js: 'test code',
      );

      final instanceField = originalField.instance();

      expect(instanceField.value[0], originalField.value[0]);
      expect(instanceField.value[1], originalField.value[1]);
      expect(instanceField.debugData, isEmpty);
    });

    test('Should convert to JSON correctly with no JS code', () {
      final blocklyField = ComponentFieldBlockly();
      final jsonValue = blocklyField.toJson();
      expect(jsonValue, '""');
    });

    test('Should convert to JSON correctly with simple JS code', () {
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
      expect(blocklyField.value[1], ComponentFieldBlockly.initialJson); // JSON should remain default
    });

    test('Should update value setter correctly', () {
      final blocklyField = ComponentFieldBlockly();
      final newJsValue = 'let x = 5;';
      blocklyField.value = newJsValue;
      expect(blocklyField.value[0], newJsValue);
    });




  });
}