import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  group('ComponentFieldDropDown Tests', () {
    late ComponentFieldDropDown dropdownField;
    late VoidCallback onUpdateCallback;
    String? updatedValueFromWidget; // To capture value from DropDownField

    setUp(() {
      onUpdateCallback = () {};
      updatedValueFromWidget = null;
      dropdownField = ComponentFieldDropDown(
        value: 'option1',
        options: {'option1': 'Option 1', 'option2': 'Option 2', 'option3': 'Option 3'},
        onUpdate: onUpdateCallback,
      );
    });

    test('Should create ComponentFieldDropDown with default values', () {
      expect(dropdownField.type, 'ComponentFieldDropDown');
      expect(dropdownField.value, 'option1');
    });

    test('Should update value correctly via updateValue method in ComponentFieldDropDown', () {
      dropdownField.updateValue('option2');
      expect(dropdownField.value, 'option2');
    });

    test('Should create an instance with the same values', () {
      final instanceField = dropdownField.instance();

      expect(instanceField.value, dropdownField.value);
      // We cannot directly test '_options' as it is private.
    });

    test('Should convert value to JSON correctly', () {
      final json = dropdownField.toJson();
      expect(json, '"option1"');
    });

    test('Should update from JSON correctly', () {
      dropdownField.updateFromJson('option3');
      expect(dropdownField.value, 'option3');
    });

    testWidgets('getField should return a DropDownField widget', (WidgetTester tester) async {
      final widget = dropdownField.getField('testName', false, [], {});
      expect(widget, isA<DropDownField>());
    });

    testWidgets('DropDownField widget should display initial value', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: dropdownField.getField('testName', false, [], {}))));
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('DropDownField widget should update ComponentFieldDropDown value when a new item is selected', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: dropdownField.getField('testName', false, [], {}))));

      // Open the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select a new item
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(dropdownField.value, 'option2');
    });

    testWidgets('DropDownField widget should call onUpdate callback when value changes', (WidgetTester tester) async {
      bool onUpdateCalled = false;
      final testField = ComponentFieldDropDown(
        value: 'option1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
        onUpdate: () => onUpdateCalled = true,
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: testField.getField('testName', false, [], {}))));

      // Open the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select a new item
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(onUpdateCalled, true);
    });

    testWidgets('DropDownField widget should call updateValue callback when value changes', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: dropdownField.getField('testName', false, [], {}))));

      // Open the dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select a new item
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      // The updateValue is called within the DropDownField, which updates the ComponentFieldDropDown's _value
      expect(dropdownField.value, 'option2');
    });

    testWidgets('getField should create a new DropDownField if field is null', (WidgetTester tester) async {
      final initialField = ComponentFieldDropDown(
        value: 'option1',
        options: {'option1': 'Option 1'},
      );
      expect(initialField.field, isNull);
      initialField.getField('testName', false, [], {});
      expect(initialField.field, isNotNull);
    });

    testWidgets('getField should reuse existing DropDownField if not null', (WidgetTester tester) async {
      final initialField = ComponentFieldDropDown(
        value: 'option1',
        options: {'option1': 'Option 1'},
      );
      final firstWidget = initialField.getField('testName', false, [], {});
      final secondWidget = initialField.getField('anotherName', true, [], {});
      expect(identical(firstWidget, secondWidget), isTrue);
    });
  });
}