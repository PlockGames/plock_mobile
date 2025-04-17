import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/game_object_type.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/pages/my_games/game_editor/asset_editor_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/add_component_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/edit_component_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';

void main() {
  group('AssetEditorPage', () {
    late GameObject testObject;
    late List<Media> testMedias;
    late List<GameObject> updatedObjects;
    late ComponentType testComponent;

    setUp(() {
      testObject = GameObject(id: 1, name: 'Test Object'); // Corrected id type
      testMedias = [];
      updatedObjects = [];
      testComponent = ComponentType();
      // On ne peut pas modifier testComponent.name car c'est un getter
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: AssetEditorPage(
          object: testObject,
          updateAsset: (gameObject) => updatedObjects.add(gameObject),
          medias: testMedias,
          canvas: EditorCanvas.scene,
        ),
      );
    }

    testWidgets('displays object name and id', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Object'), findsOneWidget);
      expect(find.text('id : 1'), findsOneWidget); // Corrected id display
    });

    testWidgets('updates object name when text field is changed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), 'New Name');
      await tester.pump();

      expect(testObject.name, 'New Name');
    });

    testWidgets('navigates to AddComponentPage when FAB is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AddComponentPage), findsOneWidget);
    });

    testWidgets('adds component to object when AddComponentPage returns a component', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      expect(testObject.components.length, 1);
      expect(updatedObjects.length, 1);
    });

    testWidgets('navigates to EditComponentPage when edit button is tapped', (WidgetTester tester) async {
      testObject.components.add(testComponent);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.byType(EditComponentPage), findsOneWidget);
    });

    testWidgets('removes component when delete button is tapped', (WidgetTester tester) async {
      testObject.components.add(testComponent);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(testObject.components.isEmpty, isTrue);
      expect(updatedObjects.length, 1);
    });


  });
}