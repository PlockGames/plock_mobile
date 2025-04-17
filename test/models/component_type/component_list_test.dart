import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/component_fields/component_field_text.dart';
import 'package:plock_mobile/models/component_fields/component_field_list.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_types/component_list.dart';

void main() {
  group('ComponentList', () {
    late ComponentList componentList;

    setUp(() {
      componentList = ComponentList();
    });

    test('should initialize with default values', () {
      expect(componentList.type, 'ComponentList');
      expect(componentList.name, 'List');
      expect(componentList.fields['name'], isA<ComponentFieldText>());
      expect((componentList.fields['name'] as ComponentFieldText).value, 'my_list');
      expect(componentList.fields['values'], isA<ComponentFieldList>());
      expect((componentList.fields['values'] as ComponentFieldList).value, isEmpty);
    });

    test('instance() should create a new instance with copied fields', () {
      // Modifier les valeurs originales pour tester la copie
      (componentList.fields['name'] as ComponentFieldText).value = 'new_name';
      (componentList.fields['values'] as ComponentFieldList).value = ['item1', 'item2'];

      final newInstance = componentList.instance() as ComponentList;

      expect(newInstance.type, 'ComponentList');
      expect(newInstance.name, 'List');
      expect(newInstance.fields['name'], isA<ComponentFieldText>());
      expect((newInstance.fields['name'] as ComponentFieldText).value, 'new_name');
      expect(newInstance.fields['values'], isA<ComponentFieldList>());
      expect((newInstance.fields['values'] as ComponentFieldList).value, ['item1', 'item2']);

      // Vérifier que c'est bien une copie et non la même référence
      expect(newInstance.fields['name'], isNot(same(componentList.fields['name'])));
      expect(newInstance.fields['values'], isNot(same(componentList.fields['values'])));
    });

    test('getDisplayComponent should return DisplayComponents with null values', () {
      final display = componentList.getDisplayComponent([], () {}, () {}, () {}, () {}, () {});

      expect(display, isA<DisplayComponents>());
      expect(display.display, isNull);
      expect(display.select, isNull);
    });

    test('getGameDisplayComponent should return null', () {
      final gameDisplay = componentList.getGameDisplayComponent(
          [], () {}, () {}, () {}, () {}, () {}
      );

      expect(gameDisplay, isNull);
    });

    test('fields should be modifiable', () {
      // Test modification du champ name
      (componentList.fields['name'] as ComponentFieldText).value = 'modified_name';
      expect((componentList.fields['name'] as ComponentFieldText).value, 'modified_name');

      // Test modification du champ values
      (componentList.fields['values'] as ComponentFieldList).value = ['a', 'b', 'c'];
      expect((componentList.fields['values'] as ComponentFieldList).value, ['a', 'b', 'c']);
    });

    test('should properly implement ComponentType interface', () {
      expect(componentList, isA<ComponentType>());
      expect(componentList.type, isNotEmpty);
      expect(componentList.name, isNotEmpty);
      expect(componentList.instance(), isA<ComponentList>());
    });
  });
}