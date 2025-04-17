import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_select_parent_page.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart'; // Import EditorCanvas

void main() {
  group('ObjectSelectParentPage', () {
    late List<GameObject> testObjects;
    late ObjectSceneComponent testObjectComponent;
    late Game testGame;

    setUp(() {
      testGame = Game(name: 'Test Game');
      testObjects = [
        GameObject(id: 1, name: 'Object 1'),
        GameObject(id: 2, name: 'Object 2'),
        GameObject(id: 3, name: 'Object 3'),
      ];
      final gameObject = GameObject(id: 4, name: 'Test Object');
      testObjectComponent = ObjectSceneComponent(
        gameObject: gameObject,
        id: 4,
        selectObject: (obj) {},
        isObjectSelected: (obj) => false,
        updateObject: (obj) {},
        getMode: () => EditorCanvas.scene,
        moveCamera: (delta) {},
        plockGame: testGame,
      );
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ObjectSelectParentPage(
          objects: testObjects,
          object: testObjectComponent,
        ),
      );
    }

    testWidgets('displays object list', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('1: Object 1'), findsOneWidget);
      expect(find.text('2: Object 2'), findsOneWidget);
      expect(find.text('3: Object 3'), findsOneWidget);
    });

    testWidgets('sets parent object when an object is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

          await tester.tap(find.text('2: Object 2'));
          await tester.pumpAndSettle();

          expect(testObjectComponent.getGameObject().parent, testObjects[1]);
        });

    testWidgets('excludes current object from list',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

          expect(find.text('4: Test Object'), findsNothing);
        });
  });
}