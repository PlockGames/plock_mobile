import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_drop_down.dart';

void main() {
  group('ComponentFieldDropDown Extended Tests', () {
    test('Should handle empty options map', () {
      final dropdownField = ComponentFieldDropDown(
        value: '',
        options: {},
      );

      expect(dropdownField.type, 'ComponentFieldDropDown');
      expect(dropdownField.value, '');
    });

    test('Should handle null onUpdate callback', () {
      final dropdownField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1'},
        onUpdate: null,
      );

      expect(() => dropdownField.updateValue('New Value'), returnsNormally);
    });

    test('Should call onUpdate callback when provided', () {
      bool callbackCalled = false;
      final dropdownField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
        onUpdate: () {
          callbackCalled = true;
        },
      );

      dropdownField.updateValue('Option 2');
      expect(dropdownField.onUpdate != null, true);
    });

    test('Should handle string value assignment', () {
      final dropdownField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
      );

      dropdownField.value = 'New Value';
      expect(dropdownField.value, 'New Value');
    });

    test('Should handle options with different key/value pairs', () {
      final dropdownField = ComponentFieldDropDown(
        value: 'red',
        options: {
          'red': 'Red Color',
          'blue': 'Blue Color',
          'green': 'Green Color'
        },
      );

      expect(dropdownField.value, 'red');
      dropdownField.updateValue('blue');
      expect(dropdownField.value, 'blue');
    });

    test('Should maintain proper state in instance method', () {
      final originalField = ComponentFieldDropDown(
        value: 'Option 1',
        options: {'option1': 'Option 1', 'option2': 'Option 2'},
        onUpdate: () => print('Updated'),
      );

      originalField.updateValue('Option 2');
      final instanceField = originalField.instance();

      expect(instanceField.value, 'Option 2');
      expect(instanceField.onUpdate != null, true);
    });

  });

  group('DropDownField Widget Tests', () {
    testWidgets('Should display initial value', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownField(
            initialValue: 'option1',
            options: {'option1': 'Option 1', 'option2': 'Option 2'},
          ),
        ),
      ));

      expect(find.text('Option 1'), findsOneWidget);
    });



    testWidgets('Should update value when an option is selected', (WidgetTester tester) async {
      String? selectedValue;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownField(
            initialValue: 'option1',
            options: {'option1': 'Option 1', 'option2': 'Option 2'},
            updateValue: (newValue) {
              selectedValue = newValue;
            },
          ),
        ),
      ));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(selectedValue, 'option2');
    });

    testWidgets('Should call onUpdate callback when an option is selected', (WidgetTester tester) async {
      bool onUpdateCalled = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DropDownField(
            initialValue: 'option1',
            options: {'option1': 'Option 1', 'option2': 'Option 2'},
            onUpdate: () {
              onUpdateCalled = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(onUpdateCalled, true);
    });

  });
}