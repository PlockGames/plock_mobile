import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/pages/my_games/game_editor/edit_component_page.dart';

void main() {
  group('EditComponentPage', () {
    late ComponentType testComponent;
    late List<Media> testMedias;
    late bool updateComponentCalled;

    setUp(() {
      updateComponentCalled = false;
      testComponent = ComponentType();
      testComponent.fields['field1'] = ComponentField();
      testComponent.fields['field1']?.value = 'value1';
      testComponent.fields['field2'] = ComponentField();
      testComponent.fields['field2']?.value = 123;
      testMedias = [];
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: EditComponentPage(
          component: testComponent,
          updateComponent: () {
            updateComponentCalled = true;
          },
          medias: testMedias,
        ),
      );
    }

    testWidgets('displays component name in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Edit Unknown'), findsOneWidget); // Comme ComponentType.name est un getter
    });

    testWidgets('displays component fields (container)', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Container), findsNWidgets(2)); // Comme ComponentField.getField retourne Container()
    });

    testWidgets('calls updateComponent when a field is updated', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      testComponent.fields['field1']?.onUpdate?.call();

      expect(updateComponentCalled, isTrue);
    });

  });
}