import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';

void main() {
  group('ComponentFieldNumber', () {
    late ComponentFieldNumber componentFieldNumber;

    setUp(() {
      componentFieldNumber = ComponentFieldNumber(
        value: 42.5,
        onUpdate: () {},
      );
    });

    test('constructor initializes correctly', () {
      expect(componentFieldNumber.value, equals(42.5));
      expect(componentFieldNumber.type, equals('ComponentFieldNumber'));
    });

    test('value setter and getter work correctly', () {
      componentFieldNumber.value = 10.75;
      expect(componentFieldNumber.value, equals(10.75));
    });

    test('toJson method returns correct string representation', () {
      String jsonResult = componentFieldNumber.toJson();
      expect(jsonResult, equals('42.5'));
    });

    test('updateFromJson method updates value correctly', () {
      componentFieldNumber.updateFromJson(99.9);

      expect(componentFieldNumber.value, equals(99.9));
    });

    test('instance method creates a copy', () {
      ComponentFieldNumber instanceCopy = componentFieldNumber.instance();

      expect(instanceCopy.value, equals(componentFieldNumber.value));
      expect(instanceCopy, isNot(same(componentFieldNumber)));
    });
  });

  group('ComponentFieldNumber Widget', () {
    testWidgets('renders TextField with correct initial value', (WidgetTester tester) async {
      final ComponentFieldNumber componentFieldNumber = ComponentFieldNumber(
        value: 42.5,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldNumber.getField('Number Field', false, [], {}),
          ),
        ),
      );

      // Vérifier que le TextField est rendu avec la valeur initiale
      expect(find.text('42.5'), findsOneWidget);
      expect(find.text('Number Field'), findsOneWidget);
    });

    testWidgets('updates value when text changes', (WidgetTester tester) async {
      bool updateCalled = false;
      final ComponentFieldNumber componentFieldNumber = ComponentFieldNumber(
        value: 42.5,
        onUpdate: () {
          updateCalled = true;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldNumber.getField('Number Field', false, [], {}),
          ),
        ),
      );

      // Entrer une nouvelle valeur
      await tester.enterText(find.byType(TextField), '99.9');
      await tester.pump();

      // Vérifier que la valeur a été mise à jour
      expect(componentFieldNumber.value, equals(99.9));
      expect(updateCalled, isTrue);
    });

    testWidgets('handles empty input by setting value to 0', (WidgetTester tester) async {
      final ComponentFieldNumber componentFieldNumber = ComponentFieldNumber(
        value: 42.5,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldNumber.getField('Number Field', false, [], {}),
          ),
        ),
      );

      // Effacer le texte
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // Vérifier que la valeur est définie à 0
      expect(componentFieldNumber.value, equals(0));
    });

    testWidgets('uses number keyboard type', (WidgetTester tester) async {
      final ComponentFieldNumber componentFieldNumber = ComponentFieldNumber(
        value: 42.5,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldNumber.getField('Number Field', false, [], {}),
          ),
        ),
      );

      // Trouver le TextField
      final TextField textField = tester.widget(find.byType(TextField));

      // Vérifier que le type de clavier est numérique
      expect(textField.keyboardType, equals(TextInputType.number));
    });
  });
}