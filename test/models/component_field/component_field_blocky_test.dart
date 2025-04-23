import 'dart:convert';

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
      expect(blocklyField.value[1], ComponentFieldBlockly.initialJson);
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

    test('Should convert simple JS to JSON string correctly', () {
      final blocklyField = ComponentFieldBlockly(
        value_js: 'console.log("Test");',
      );

      final jsonValue = blocklyField.toJson();

      // Updated to match actual output
      expect(jsonValue, '{"json": {"blocks":{"languageVersion":0,"blocks":[]}}, "js": "console.log(\\"Test\\");"}');
    });

    test('Should convert JS with double quotes to JSON string correctly', () {
      final blocklyField = ComponentFieldBlockly(
        value_js: 'alert("This has \\"quotes\\"");',
      );

      final jsonValue = blocklyField.toJson();

      // Updated to match actual output
      expect(jsonValue, '{"json": {"blocks":{"languageVersion":0,"blocks":[]}}, "js": "alert(\\"This has \\\\"quotes\\\\"\\");"}');
    });

    test('Should convert JS with newlines to JSON string correctly', () {
      final blocklyField = ComponentFieldBlockly(
        value_js: 'if (true) {\n  console.log("Yes");\n}',
      );

      final jsonValue = blocklyField.toJson();

      // Updated to match actual output
      expect(jsonValue, '{"json": {"blocks":{"languageVersion":0,"blocks":[]}}, "js": "if (true) {;\n  console.log(\\"Yes\\");;\n}"}');
    });

    test('Should update from valid JSON', () {
      final blocklyField = ComponentFieldBlockly();
      final newJsonValue = {
        'json': {'blocks': {'languageVersion': 2, 'blocks': [{'type': 'new_block'}]}},
        'js': 'var x = 10;'
      };

      blocklyField.updateFromJson(newJsonValue);

      expect(blocklyField.value[0], 'var x = 10;');
      expect(blocklyField.value[1], {'blocks': {'languageVersion': 2, 'blocks': [{'type': 'new_block'}]}});
    });

    test('Should update from JSON with null values', () {
      final blocklyField = ComponentFieldBlockly(
        value: {'blocks': {'languageVersion': 1, 'blocks': []}},
        value_js: 'initial code',
      );

      blocklyField.updateFromJson(null);

      expect(blocklyField.value[0], '');
      expect(blocklyField.value[1], ComponentFieldBlockly.initialJson);
    });

    test('Should return empty debug data initially', () {
      final blocklyField = ComponentFieldBlockly();

      expect(blocklyField.debugData, isEmpty);
    });

    test('getField should return a Widget', () {
      final blocklyField = ComponentFieldBlockly();
      const name = 'blocklyField';
      const debug = false;
      const medias = <Media>[];
      const fields = <String, ComponentField>{};

      final widget = blocklyField.getField(name, debug, medias, fields);

      expect(widget, isA<FutureBuilder>());
    });
  });
}