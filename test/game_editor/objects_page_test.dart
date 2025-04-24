import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/objects_page.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

// Mock ObjectSceneComponent
class MockObjectSceneComponent implements ObjectComponent {
  GameObject gameObject;

  MockObjectSceneComponent({required this.gameObject});

  @override
  GameObject getGameObject() => gameObject;

  @override
  void updateDisplay() {}
}

void main() {
  group('ObjectsPage', () {
    late List<ObjectComponent> testObjects; // Change to ObjectComponent
    late Function(ObjectComponent, List<GameObject>, EditorCanvas canvas) openEditor;
    late Function(ObjectComponent, EditorCanvas canvas) removeObject;
    late EditorCanvas testCanvas;
    late Game testGame;

    setUp(() {
      testGame = Game(name: 'Test Game');
      final gameObject1 = GameObject(id: 1, name: 'Object 1');
      final gameObject2 = GameObject(id: 2, name: 'Object 2');
      gameObject2.enabled = false;
      gameObject2.visible = false;
      gameObject2.locked = true;

      testObjects = [
        MockObjectSceneComponent(gameObject: gameObject1), // Use MockObjectSceneComponent
        MockObjectSceneComponent(gameObject: gameObject2), // Use MockObjectSceneComponent
      ];
      openEditor = (object, objects, canvas) {};
      removeObject = (object, canvas) {};
      testCanvas = EditorCanvas.scene;
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ObjectsPage(
          objects: testObjects,
          openEditor: openEditor,
          removeObject: removeObject,
          canvas: testCanvas,
        ),
      );
    }

    testWidgets('displays object names', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Object 1'), findsOneWidget);
      expect(find.text('Object 2'), findsOneWidget);
    });

    testWidgets('toggles object enabled state', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.check_box_outline_blank).last);
      await tester.pumpAndSettle();

      expect(testObjects[1].getGameObject().enabled, true);

      await tester.tap(find.byIcon(Icons.check_box).last);
      await tester.pumpAndSettle();

      expect(testObjects[1].getGameObject().enabled, false);
    });

    testWidgets('toggles object visible state', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.visibility_off).last);
      await tester.pumpAndSettle();

      expect(testObjects[1].getGameObject().visible, true);

      await tester.tap(find.byIcon(Icons.visibility).last);
      await tester.pumpAndSettle();

      expect(testObjects[1].getGameObject().visible, false);
    });

    testWidgets('toggles object locked state', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.lock).last);
      await tester.pumpAndSettle();

      expect(testObjects[1].getGameObject().locked, false);

      await tester.tap(find.byIcon(Icons.lock_open).last);
      await tester.pumpAndSettle();

      expect(testObjects[1].getGameObject().locked, true);
    });

    testWidgets('removes an object', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.delete).last);
      await tester.pumpAndSettle();

      expect(testObjects.length, 1);
      expect(find.text('Object 2'), findsNothing);
    });

    testWidgets('navigates to object editor when an object is tapped',
            (WidgetTester tester) async {
          bool editorOpened = false;
          openEditor = (object, objects, canvas) {
            editorOpened = true;
          };

          await tester.pumpWidget(createWidgetUnderTest());

          await tester.tap(find.text('Object 1'));
          await tester.pumpAndSettle();

          expect(editorOpened, true);
        });
  });
}