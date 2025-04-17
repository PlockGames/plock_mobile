import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';

void main() {
  group('ComponentFieldText Widget', () {
    testWidgets('renders with initial value', (WidgetTester tester) async {
      const testValue = 'Initial text';
      final componentFieldText = ComponentFieldText(
        value: testValue,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldText.getField('Text Field', false, [], {}),
          ),
        ),
      );

      // Vérifie que le champ texte est affiché avec la valeur initiale
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text(testValue), findsOneWidget);
      expect(find.text('Text Field'), findsOneWidget); // Vérifie le label
    });

    testWidgets('updates value when text changes', (WidgetTester tester) async {
      const initialValue = 'Initial';
      const newValue = 'Updated text';
      bool updateCalled = false;

      final componentFieldText = ComponentFieldText(
        value: initialValue,
        onUpdate: () {
          updateCalled = true;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldText.getField('Text Field', false, [], {}),
          ),
        ),
      );

      // Saisir du texte dans le champ
      await tester.enterText(find.byType(TextField), newValue);
      await tester.pump();

      // Vérifie que la valeur a été mise à jour et que le callback a été appelé
      expect(componentFieldText.value, newValue);
      expect(updateCalled, true);
    });

    test('instance creates a copy with same values', () {
      const testValue = 'Test value';
      bool updateCalled = false;

      final original = ComponentFieldText(
        value: testValue,
        onUpdate: () {
          updateCalled = true;
        },
      );

      final copy = original.instance();

      expect(copy.value, testValue);
      expect(copy.type, 'ComponentFieldText');

      // Vérifie que le callback est bien copié
      copy.onUpdate!();
      expect(updateCalled, true);
    });

    test('toJson returns correct JSON string', () {
      const testValue = 'Test value';
      final field = ComponentFieldText(value: testValue, onUpdate: () {});

      expect(field.toJson(), '"$testValue"');
    });

    test('updateFromJson updates value correctly', () {
      const initialValue = 'Initial';
      const jsonValue = 'From JSON';
      final field = ComponentFieldText(value: initialValue, onUpdate: () {});

      expect(field.value, initialValue);
      field.updateFromJson(jsonValue);
      expect(field.value, jsonValue);
    });

    test('value setter updates internal value', () {
      const initialValue = 'Initial';
      const newValue = 'New value';
      final field = ComponentFieldText(value: initialValue, onUpdate: () {});

      expect(field.value, initialValue);
      field.value = newValue;
      expect(field.value, newValue);
    });
  });
}