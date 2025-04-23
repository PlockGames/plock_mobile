import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/game.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/game_object_type.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/object_editor_page.dart';

void main() {
  group('ObjectEditorPage', () {
    late ObjectSceneComponent testObjectComponent;
    late List<GameObject> testObjects;
    late List<Media> testMedias;
    late EditorCanvas testCanvas;
    late Game testGame;

    setUp(() {
      testGame = Game(name: 'Test Game');
      final gameObject = GameObject(id: 1, name: 'Test Object');
      gameObject.components.add(ComponentType());
      testObjectComponent = ObjectSceneComponent(
        gameObject: gameObject,
        id: 1,
        selectObject: (obj) {},
        isObjectSelected: (obj) => false,
        updateObject: (obj) {},
        getMode: () => EditorCanvas.scene,
        moveCamera: (delta) {},
        plockGame: testGame,
      );
      testObjects = [gameObject];
      testMedias = [];
      testCanvas = EditorCanvas.scene;
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ObjectEditorPage(
          object: testObjectComponent,
          objects: testObjects,
          medias: testMedias,
          canvas: testCanvas,
        ),
      );
    }

    testWidgets('displays object name and id', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Object'), findsOneWidget);
      expect(find.text('id : 1'), findsOneWidget);
    });

    testWidgets('updates object name when text is entered',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

          await tester.enterText(find.byType(TextField).first, 'New Object Name');
          await tester.pumpAndSettle();

          expect(testObjectComponent.getGameObject().name, 'New Object Name');
        });

    testWidgets('adds a new component when the add button is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(createWidgetUnderTest());

          await tester.tap(find.byIcon(Icons.add));
          await tester.pumpAndSettle();

          expect(find.text('Add Component'), findsOneWidget);
        });

    testWidgets('convert asset to object', (WidgetTester tester) async {
      testObjectComponent.getGameObject().type = GameObjectType.asset;

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Convert to Object'));
      await tester.pumpAndSettle();

      expect(testObjectComponent.getGameObject().type, GameObjectType.object);
    });
  });
}