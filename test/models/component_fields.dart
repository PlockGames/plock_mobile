import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_blocky.dart';
import 'package:plock_mobile/models/component_fields/component_field_color.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';

void main() {
  group('Test Component Fields Blockly', () {

    test('Should create a default Blockly Field', () {
      ComponentFieldBlockly componentFieldBlockly = ComponentFieldBlockly();
      List values = componentFieldBlockly.value;

      expect(componentFieldBlockly, isNotNull);
      expect(componentFieldBlockly.type, 'ComponentFieldBlocky');
      expect(values.length, 2);
      expect(values[0], "");
      expect(values[1], {'blocks': {'languageVersion': 0, 'blocks': []}});
    });

    test('should create a Blockly Field with values', () {
      ComponentFieldBlockly componentFieldBlockly = ComponentFieldBlockly(value: {'blocks': {'languageVersion': 0, 'blocks': ["myblock"]}}, value_lua: "test");
      List values = componentFieldBlockly.value;

      expect(componentFieldBlockly, isNotNull);
      expect(componentFieldBlockly.type, 'ComponentFieldBlocky');
      expect(values.length, 2);
      expect(values[0], "test");
      expect(values[1], {'blocks': {'languageVersion': 0, 'blocks': ["myblock"]}});
    });
  });

  group('Test Component Fields Color', () {

    test('Should create a Component Field Color', () {

      ComponentFieldColour componentFieldColour = ComponentFieldColour(value: const Color(0xff000000));
      Color value = componentFieldColour.value;

      expect(componentFieldColour, isNotNull);
      expect(componentFieldColour.type, 'ComponentFieldColor');
      expect(value, const Color(0xff000000));

    });

  });

  group('Test Component Field Drop Down', () {

    test('Should create a default component field drop down', () {
      ComponentFieldDropDown componentFieldDropDown = ComponentFieldDropDown(value: 'test', options: {'test': 'test'});
      String value = componentFieldDropDown.value;

      expect(componentFieldDropDown, isNotNull);
      expect(componentFieldDropDown.type, 'ComponentFieldDropDown');
      expect(value, 'test');

    });

  });

  group('Test Component Field Number', () {

    test('Should create a default component field number', () {
      ComponentFieldNumber componentFieldNumber = ComponentFieldNumber(value: 1);
      int value = componentFieldNumber.value;

      expect(componentFieldNumber, isNotNull);
      expect(componentFieldNumber.type, 'ComponentFieldNumber');
      expect(value, 1);

    });

  });

  group('Test Component Field Number', () {

    test('Should create a default component field text', () {
      ComponentFieldText componentFieldText = ComponentFieldText(value: 'test');
      String value = componentFieldText.value;

      expect(componentFieldText, isNotNull);
      expect(componentFieldText.type, 'ComponentFieldText');
      expect(value, 'test');
    });

  });

}