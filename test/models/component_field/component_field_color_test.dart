import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/component_fields/component_field_color.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  group('ComponentFieldColour Tests', () {
    test('Should create ComponentFieldColour with default values', () {
      final colourField = ComponentFieldColour(value: Colors.red);

      expect(colourField.type, 'ComponentFieldColor');
      expect(colourField.value, Colors.red);
    });

    test('Should update value correctly', () {
      final colourField = ComponentFieldColour(value: Colors.red);
      colourField.updateValue(Colors.blue);

      expect(colourField.value, Colors.blue);
    });

    test('Should create an instance with the same values', () {
      final originalField = ComponentFieldColour(value: Colors.green);
      final instanceField = originalField.instance();

      expect(instanceField.value, originalField.value);
    });

    test('Should convert color to JSON correctly', () {
      final colourField = ComponentFieldColour(value: Colors.red);
      final json = colourField.toJson();

      // Ajustez cette attente si la méthode toJson ne retourne pas de guillemets
      expect(json, '"FFF44336"');
    });
  });

  group('ColourField Widget Tests', () {
    testWidgets('Should display initial color correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ColourField(initialValue: Colors.blue),
        ),
      ));

      final colourField = tester.widget<ColourField>(find.byType(ColourField));
      expect(colourField.value, Colors.blue);
    });
  });
}
