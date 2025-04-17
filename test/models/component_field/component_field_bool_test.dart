import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/component_fields/component_field_bool.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ComponentFieldBool Tests', () {
    test('Should create ComponentFieldBool with initial value', () {
      final boolField = ComponentFieldBool(value: true);

      expect(boolField.type, 'ComponentFieldBool');
      expect(boolField.value, isTrue);
    });

    test('Should create ComponentFieldBool with false value', () {
      final boolField = ComponentFieldBool(value: false);

      expect(boolField.value, isFalse);
    });

    test('Should create an instance with the same value', () {
      final originalField = ComponentFieldBool(value: true);
      final instanceField = originalField.instance();

      expect(instanceField.value, originalField.value);
    });

    test('Should convert to JSON correctly', () {
      final trueField = ComponentFieldBool(value: true);
      final falseField = ComponentFieldBool(value: false);

      expect(trueField.toJson(), '"true"');
      expect(falseField.toJson(), '"false"');
    });

    test('Should update from JSON', () {
      final boolField = ComponentFieldBool(value: false);

      boolField.updateFromJson("true");
      expect(boolField.value, isTrue);

      boolField.updateFromJson("false");
      expect(boolField.value, isFalse);
    });

  //  test('Should call onUpdate callback when value changes', () {
   //   bool updateCalled = false;
   //   final boolField = ComponentFieldBool(
   //     value: false,
   //     onUpdate: () {
   //       updateCalled = true;
    //    },
    //  );

      // Ensure we're not setting the same value
   //   expect(boolField.value, isFalse); // Verify initial state
   //   boolField.value = true;           // Change the value
   //   expect(updateCalled, isTrue);     // Verify callback was called
  //    expect(boolField.value, isTrue);  // Verify value actually changed
//    });




    testWidgets('Should create CheckboxListTile widget', (WidgetTester tester) async {
      final boolField = ComponentFieldBool(value: false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: boolField.getField('Test Checkbox', false, [], {}),
        ),
      ));

      // Find the CheckboxListTile
      final checkboxFinder = find.byType(CheckboxListTile);
      expect(checkboxFinder, findsOneWidget);

      // Verify initial state
      final CheckboxListTile checkboxListTile = tester.widget(checkboxFinder);
      expect(checkboxListTile.value, isFalse);
      expect(checkboxListTile.title, isA<Text>());

      // Verify title text
      final textFinder = find.text('Test Checkbox');
      expect(textFinder, findsOneWidget);
    });

    testWidgets('Should toggle checkbox value', (WidgetTester tester) async {
      final boolField = ComponentFieldBool(value: false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: boolField.getField('Test Checkbox', false, [], {}),
        ),
      ));

      // Find the CheckboxListTile
      final checkboxFinder = find.byType(CheckboxListTile);

      // Tap the checkbox to toggle
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Verify the value has changed
      final CheckboxListTile updatedCheckboxListTile = tester.widget(checkboxFinder);
      expect(updatedCheckboxListTile.value, isTrue);
      expect(boolField.value, isTrue);
    });
  });
}