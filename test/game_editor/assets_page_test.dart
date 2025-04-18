import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/game.dart' as Plock;
import 'package:plock_mobile/models/games/game_object.dart' as Plock;
import 'package:plock_mobile/models/games/game_object_type.dart';
import 'package:plock_mobile/pages/my_games/game_editor/asset_editor_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/assets_page.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/editor_canvas.dart';

void main() {
  group('AssetsPage', () {
    late Plock.Game testGame;
    late List<Plock.GameObject> spawnedAssets;
    late List<Plock.GameObject> updatedAssets;

    setUp(() {
      testGame = Plock.Game(name: 'Test Game');
      testGame.assets.add(Plock.GameObject(id: 1, name: 'Asset 1'));
      testGame.assets.add(Plock.GameObject(id: 2, name: 'Asset 2'));
      spawnedAssets = [];
      updatedAssets = [];
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: AssetsPage(
          game: testGame,
          spawnAsset: (asset, canvas) {
            print('spawnAsset called with: ${asset.name} on canvas: $canvas');
            spawnedAssets.add(asset);
          },
          updateAsset: (asset) => updatedAssets.add(asset),
          canvas: EditorCanvas.scene,
        ),
      );
    }

    testWidgets('displays assets from the game', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Asset 1'), findsOneWidget);
      expect(find.text('Asset 2'), findsOneWidget);
    });

    testWidgets('navigates to AssetEditorPage when an asset is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Asset 1'));
      await tester.pumpAndSettle();

      expect(find.byType(AssetEditorPage), findsOneWidget);
      expect(find.text('Asset 1'), findsWidgets);
    });

    testWidgets('adds a new asset when the FAB is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(testGame.assets.length, 3);
      expect(testGame.assets.last.name, 'New Asset');
    });

    testWidgets('adds a new UI asset when the FAB is tapped in UI mode', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AssetsPage(
          game: testGame,
          spawnAsset: (asset, canvas) => spawnedAssets.add(asset),
          updateAsset: (asset) => updatedAssets.add(asset),
          canvas: EditorCanvas.ui,
        ),
      ));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(testGame.uiAssets.length, 1);
      expect(testGame.uiAssets.last.name, 'New Asset');
    });

    testWidgets('displays assets from the UI assets when in UI mode', (WidgetTester tester) async {
      testGame.uiAssets.add(Plock.GameObject(id: 1, name: 'UI Asset 1'));

      await tester.pumpWidget(MaterialApp(
        home: AssetsPage(
          game: testGame,
          spawnAsset: (asset, canvas) => spawnedAssets.add(asset),
          updateAsset: (asset) => updatedAssets.add(asset),
          canvas: EditorCanvas.ui,
        ),
      ));

      expect(find.text('UI Asset 1'), findsOneWidget);
    });
  });
}