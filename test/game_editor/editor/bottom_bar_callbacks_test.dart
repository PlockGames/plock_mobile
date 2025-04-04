import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/scene.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/bottom_bar_callbacks.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_ui_component.dart';

void main() {
  group('BottomBarCallbacks Tests', () {
    test('BottomBarCallbacks initializes correctly', () {
      final callbacks = BottomBarCallbacks(
        selectObject: (object) {},
        openEditor: (object, objects, canvas) {},
        addGameObject: () => ObjectComponent(),
        addUIObject: () => ObjectUiComponent(),
        updateObject: (object) {},
        updateUIObject: (object) {},
        removeGameObject: (object) {},
        removeUIObject: (object) {},
        getSelectedObject: () => ObjectComponent(),
        getObjects: () => <ObjectComponent>[],
        getUiObjects: () => <ObjectUiComponent>[],
        testGame: () {},
        goBack: () {},
        openObjects: (objects, canvas) {},
        openAssets: (spawnAsset, updateAsset, canvas) {},
        spawnAsset: (asset) {},
        updateAsset: (asset) {},
        openMedias: () {},
        changeMode: () {},
        getMode: () => 'edit',
        getCanvas: () => EditorCanvas(),
        changeCanvas: () {},
        openScenes: (changeScene) {},
        changeScene: (scene) {},
      );

      expect(callbacks, isNotNull);
      expect(callbacks.selectObject, isNotNull);
      expect(callbacks.openEditor, isNotNull);
      expect(callbacks.addGameObject, isNotNull);
      expect(callbacks.addUIObject, isNotNull);
      expect(callbacks.updateObject, isNotNull);
      expect(callbacks.updateUIObject, isNotNull);
      expect(callbacks.removeGameObject, isNotNull);
      expect(callbacks.removeUIObject, isNotNull);
      expect(callbacks.getSelectedObject, isNotNull);
      expect(callbacks.getObjects, isNotNull);
      expect(callbacks.getUiObjects, isNotNull);
      expect(callbacks.testGame, isNotNull);
      expect(callbacks.goBack, isNotNull);
      expect(callbacks.openObjects, isNotNull);
      expect(callbacks.openAssets, isNotNull);
      expect(callbacks.spawnAsset, isNotNull);
      expect(callbacks.updateAsset, isNotNull);
      expect(callbacks.openMedias, isNotNull);
      expect(callbacks.changeMode, isNotNull);
      expect(callbacks.getMode, isNotNull);
      expect(callbacks.getCanvas, isNotNull);
      expect(callbacks.changeCanvas, isNotNull);
      expect(callbacks.openScenes, isNotNull);
      expect(callbacks.changeScene, isNotNull);
    });

    test('BottomBarCallbacks functions are called correctly', () {
      bool selectObjectCalled = false;
      bool openEditorCalled = false;
      bool addGameObjectCalled = false;
      bool addUIObjectCalled = false;
      bool updateObjectCalled = false;
      bool updateUIObjectCalled = false;
      bool removeGameObjectCalled = false;
      bool removeUIObjectCalled = false;
      bool getSelectedObjectCalled = false;
      bool getObjectsCalled = false;
      bool getUiObjectsCalled = false;
      bool testGameCalled = false;
      bool goBackCalled = false;
      bool openObjectsCalled = false;
      bool openAssetsCalled = false;
      bool spawnAssetCalled = false;
      bool updateAssetCalled = false;
      bool openMediasCalled = false;
      bool changeModeCalled = false;
      bool getModeCalled = false;
      bool getCanvasCalled = false;
      bool changeCanvasCalled = false;
      bool openScenesCalled = false;
      bool changeSceneCalled = false;

      final callbacks = BottomBarCallbacks(
        selectObject: (object) {
          selectObjectCalled = true;
        },
        openEditor: (object, objects, canvas) {
          openEditorCalled = true;
        },
        addGameObject: () {
          addGameObjectCalled = true;
          return ObjectComponent();
        },
        addUIObject: () {
          addUIObjectCalled = true;
          return ObjectUiComponent();
        },
        updateObject: (object) {
          updateObjectCalled = true;
        },
        updateUIObject: (object) {
          updateUIObjectCalled = true;
        },
        removeGameObject: (object) {
          removeGameObjectCalled = true;
        },
        removeUIObject: (object) {
          removeUIObjectCalled = true;
        },
        getSelectedObject: () {
          getSelectedObjectCalled = true;
          return ObjectComponent();
        },
        getObjects: () {
          getObjectsCalled = true;
          return <ObjectComponent>[];
        },
        getUiObjects: () {
          getUiObjectsCalled = true;
          return <ObjectUiComponent>[];
        },
        testGame: () {
          testGameCalled = true;
        },
        goBack: () {
          goBackCalled = true;
        },
        openObjects: (objects, canvas) {
          openObjectsCalled = true;
        },
        openAssets: (spawnAsset, updateAsset, canvas) {
          openAssetsCalled = true;
        },
        spawnAsset: (asset) {
          spawnAssetCalled = true;
        },
        updateAsset: (asset) {
          updateAssetCalled = true;
        },
        openMedias: () {
          openMediasCalled = true;
        },
        changeMode: () {
          changeModeCalled = true;
        },
        getMode: () {
          getModeCalled = true;
          return 'edit';
        },
        getCanvas: () {
          getCanvasCalled = true;
          return EditorCanvas();
        },
        changeCanvas: () {
          changeCanvasCalled = true;
        },
        openScenes: (changeScene) {
          openScenesCalled = true;
        },
        changeScene: (scene) {
          changeSceneCalled = true;
        },
      );

      callbacks.selectObject(ObjectComponent());
      callbacks.openEditor(ObjectComponent(), <GameObject>[], EditorCanvas());
      callbacks.addGameObject();
      callbacks.addUIObject();
      callbacks.updateObject(ObjectComponent());
      callbacks.updateUIObject(ObjectUiComponent());
      callbacks.removeGameObject(ObjectComponent());
      callbacks.removeUIObject(ObjectUiComponent());
      callbacks.getSelectedObject();
      callbacks.getObjects();
      callbacks.getUiObjects();
      callbacks.testGame();
      callbacks.goBack();
      callbacks.openObjects(<ObjectComponent>[], EditorCanvas());
      callbacks.openAssets((asset) {}, (asset) {}, EditorCanvas());
      callbacks.spawnAsset(GameObject());
      callbacks.updateAsset(GameObject());
      callbacks.openMedias();
      callbacks.changeMode();
      callbacks.getMode();
      callbacks.getCanvas();
      callbacks.changeCanvas();
      callbacks.openScenes((scene) {});
      callbacks.changeScene(Scene());

      expect(selectObjectCalled, true);
      expect(openEditorCalled, true);
      expect(addGameObjectCalled, true);
      expect(addUIObjectCalled, true);
      expect(updateObjectCalled, true);
      expect(updateUIObjectCalled, true);
      expect(removeGameObjectCalled, true);
      expect(removeUIObjectCalled, true);
      expect(getSelectedObjectCalled, true);
      expect(getObjectsCalled, true);
      expect(getUiObjectsCalled, true);
      expect(testGameCalled, true);
      expect(goBackCalled, true);
      expect(openObjectsCalled, true);
      expect(openAssetsCalled, true);
      expect(spawnAssetCalled, true);
      expect(updateAssetCalled, true);
      expect(openMediasCalled, true);
      expect(changeModeCalled, true);
      expect(getModeCalled, true);
      expect(getCanvasCalled, true);
      expect(changeCanvasCalled, true);
      expect(openScenesCalled, true);
      expect(changeSceneCalled, true);
    });
  });
}