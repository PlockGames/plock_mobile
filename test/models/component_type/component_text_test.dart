import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_color.dart';
import 'package:plock_mobile/models/component_types/component_text.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';

void main() {
  group('ComponentText', () {
    late ComponentText componentText;

    setUp(() {
      componentText = ComponentText();
    });

    test('should have correct type and name', () {
      expect(componentText.type, equals('ComponentText'));
      expect(componentText.name, equals('Text'));
    });

    test('should initialize with correct default fields', () {
      expect(componentText.fields['text'], isA<ComponentFieldText>());
      expect(componentText.fields['text']!.value, equals('Text'));

      expect(componentText.fields['size'], isA<ComponentFieldNumber>());
      expect(componentText.fields['size']!.value, equals(1.0));

      expect(componentText.fields['color'], isA<ComponentFieldColour>());
      expect(componentText.fields['color']!.value, equals(Color(0xffffffff)));
    });

    test('instance method should create a new ComponentText with same field values', () {
      // Modify original component
      componentText.fields['text']!.value = 'Custom Text';
      componentText.fields['size']!.value = 2.5;
      componentText.fields['color']!.value = Color(0xffFF0000);

      // Create new instance
      var newInstance = componentText.instance();

      // Verify new instance is of correct type
      expect(newInstance, isA<ComponentText>());

      // Verify field values are copied
      expect(newInstance.fields['text']!.value, equals('Custom Text'));
      expect(newInstance.fields['size']!.value, equals(2.5));
      expect(newInstance.fields['color']!.value, equals(Color(0xffFF0000)));
      expect(newInstance, isNot(same(componentText)));
    });

    test('fields should be independently modifiable', () {
      // Modify individual fields
      componentText.fields['text']!.value = 'Updated Text';
      componentText.fields['size']!.value = 2.0;
      componentText.fields['color']!.value = Color(0xffFF0000);

      // Check each field is updated correctly
      expect(componentText.fields['text']!.value, equals('Updated Text'));
      expect(componentText.fields['size']!.value, equals(2.0));
      expect(componentText.fields['color']!.value, equals(Color(0xffFF0000)));
    });

    test('fields should support different types of values', () {
      // Test text field
      componentText.fields['text']!.value = 'Hello World';
      expect(componentText.fields['text']!.value, equals('Hello World'));

      // Test size field
      componentText.fields['size']!.value = 0.5;
      expect(componentText.fields['size']!.value, equals(0.5));

      // Test color field
      componentText.fields['color']!.value = Color(0xff000000);
      expect(componentText.fields['color']!.value, equals(Color(0xff000000)));
    });
  });

  group('ComponentFieldTextField', () {

    testWidgets('TextField onChanged updates the field value', (tester) async {
      final field = ComponentFieldText(value: 'initial text');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: field.getField('Text Field', false, [], {}),
        ),
      ));

      await tester.enterText(find.widgetWithText(TextField, 'Text Field'), 'new text');
      await tester.pump(); // Trigger rebuild after text input

      expect(field.value, 'new text');
    });

    testWidgets('TextField onChanged calls onUpdate if provided', (tester) async {
      String? updatedValue;
      void testOnUpdate() {
        updatedValue = 'updated!';
      }
      final field = ComponentFieldText(value: 'initial', onUpdate: testOnUpdate);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: field.getField('Text Field', false, [], {}),
        ),
      ));

      await tester.enterText(find.widgetWithText(TextField, 'Text Field'), 'updated!');
      await tester.pump();

      expect(updatedValue, 'updated!');
    });

    testWidgets('TextField has correct label text', (tester) async {
      final field = ComponentFieldText(value: 'some text');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: field.getField('Custom Label', false, [], {}),
        ),
      ));

      expect(find.widgetWithText(TextField, 'Custom Label'), findsOneWidget);
    });

  });
}