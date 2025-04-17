import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/component_field_list.dart';

void main() {
  group('ComponentFieldList', () {
    late ComponentFieldList componentFieldList;
    List<String> initialOptions = ['Option 1', 'Option 2'];

    setUp(() {
      componentFieldList = ComponentFieldList(
        value: initialOptions,
        onUpdate: () {},
      );
    });

    test('constructor initializes correctly', () {
      expect(componentFieldList.value, equals(initialOptions));
      expect(componentFieldList.type, equals('ComponentFieldList'));
    });

    test('toJson method generates correct JSON', () {
      String jsonResult = componentFieldList.toJson();
      expect(jsonResult, equals('["Option 1","Option 2"]'));
    });

    test('updateFromJson method updates value correctly', () {
      List<dynamic> jsonData = ['New Option 1', 'New Option 2', 'New Option 3'];

      componentFieldList.updateFromJson(jsonData);

      expect(componentFieldList.value, equals(['New Option 1', 'New Option 2', 'New Option 3']));
    });

    test('instance method creates a copy', () {
      ComponentFieldList instanceCopy = componentFieldList.instance();

      expect(instanceCopy.value, equals(componentFieldList.value));
      expect(instanceCopy, isNot(same(componentFieldList)));
    });
  });

  group('ListField Widget', () {
    testWidgets('renders initial options', (WidgetTester tester) async {
      final List<String> options = ['Option 1', 'Option 2'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListField(
              options: options,
              onUpdate: (text) {},
              updateValue: () {},
            ),
          ),
        ),
      );

      // Vérifier que les options sont affichées
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Value'), findsNWidgets(2));
    });

    testWidgets('can add new option', (WidgetTester tester) async {
      final List<String> options = ['Option 1', 'Option 2'];
      bool updateCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListField(
              options: options,
              onUpdate: (text) {},
              updateValue: () {
                updateCalled = true;
              },
            ),
          ),
        ),
      );

      // Trouver et appuyer sur le bouton "Add Value"
      await tester.tap(find.text('Add Value'));
      await tester.pump();

      // Vérifier qu'une nouvelle option a été ajoutée
      expect(options.length, equals(3));
      expect(options.last, equals(''));
      expect(updateCalled, isTrue);
    });

    testWidgets('can remove an option', (WidgetTester tester) async {
      final List<String> options = ['Option 1', 'Option 2'];
      bool updateCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListField(
              options: options,
              onUpdate: (text) {},
              updateValue: () {
                updateCalled = true;
              },
            ),
          ),
        ),
      );

      // Trouver et appuyer sur le premier bouton "Remove"
      await tester.tap(find.text('Remove').first);
      await tester.pump();

      // Vérifier qu'une option a été supprimée
      expect(options.length, equals(1));
      expect(options.first, equals('Option 2'));
      expect(updateCalled, isTrue);
    });

    testWidgets('can update option text', (WidgetTester tester) async {
      final List<String> options = ['Option 1', 'Option 2'];
      String? updatedText;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListField(
              options: options,
              onUpdate: (text) {
                updatedText = text;
              },
              updateValue: () {},
            ),
          ),
        ),
      );

      // Entrer un nouveau texte dans le premier TextField
      await tester.enterText(find.byType(TextField).first, 'Updated Option');
      await tester.pump();

      // Vérifier que le texte a été mis à jour
      expect(options.first, equals('Updated Option'));
      expect(updatedText, equals('Updated Option'));
    });
  });
}