import 'package:test/test.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_flame/component_flame_text.dart';
import 'package:flame/components.dart';

import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_types/component_variable.dart';

void main() {
  group('ComponentVariable', () {
    late ComponentVariable component;

    setUp(() {
      component = ComponentVariable();
    });

    test('type should return correct type string', () {
      expect(component.type, equals('ComponentVariable'));
    });

    test('name should return correct display name', () {
      expect(component.name, equals('Variable'));
    });

    test('should initialize with default fields', () {
      expect(component.fields.containsKey('name'), isTrue);
      expect(component.fields.containsKey('value'), isTrue);

      final nameField = component.fields['name'] as ComponentFieldText;
      final valueField = component.fields['value'] as ComponentFieldText;

      expect(nameField.value, equals('my_variable'));
      expect(valueField.value, equals('0'));
    });

    test('instance should create a copy with same fields', () {
      final copy = component.instance() as ComponentVariable;

      expect(copy.type, equals(component.type));
      expect(copy.name, equals(component.name));

      // Vérifie que les champs sont les mêmes mais pas la même instance
      expect(copy.fields['name']?.value, equals(component.fields['name']?.value));
      expect(copy.fields['value']?.value, equals(component.fields['value']?.value));
      expect(copy.fields['name'], isNot(same(component.fields['name'])));
      expect(copy.fields['value'], isNot(same(component.fields['value'])));
    });

    test('getDisplayComponent should return DisplayComponents with null display and select', () {
      final display = component.getDisplayComponent(
        [],
            () {},
            () {},
            () {},
            () {},
            () {},
      );

      expect(display.display, isNull);
      expect(display.select, isNull);
    });

    test('getGameDisplayComponent should return null', () {
      final gameComponent = component.getGameDisplayComponent(
        [],
            () {},
            () {},
            () {},
            () {},
            () {},
      );

      expect(gameComponent, isNull);
    });

    test('modifying fields should not affect other instances', () {
      final copy = component.instance() as ComponentVariable;

      // Modifie l'original
      (component.fields['name'] as ComponentFieldText).value = 'modified';
      (component.fields['value'] as ComponentFieldText).value = '42';

      // Vérifie que la copie n'est pas affectée
      expect((copy.fields['name'] as ComponentFieldText).value, equals('my_variable'));
      expect((copy.fields['value'] as ComponentFieldText).value, equals('0'));
    });
  });
}