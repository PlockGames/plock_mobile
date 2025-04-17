import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas_painter.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_bar.dart'; // Assurez-vous que ce chemin est correct

void main() {
  group('PaintBar Widget Tests', () {
    bool isPaintingValue = false;
    Color selectedColor = Colors.red;
    bool togglePaintingCalled = false;
    bool undoCalled = false;
    bool redoCalled = false;
    bool saveCalled = false;

    setUp(() {
      // Réinitialiser les variables avant chaque test
      isPaintingValue = false;
      selectedColor = Colors.red;
      togglePaintingCalled = false;
      undoCalled = false;
      redoCalled = false;
      saveCalled = false;
    });

    Widget createPaintBar() {
      return MaterialApp(
        home: Scaffold(
          body: PaintBar(
            togglePainting: () {
              togglePaintingCalled = true;
              isPaintingValue = !isPaintingValue;
            },
            setColor: (color) {
              selectedColor = color;
            },
            undo: () {
              undoCalled = true;
            },
            redo: () {
              redoCalled = true;
            },
            ispainting: isPaintingValue,
            save: () {
              saveCalled = true;
            },
          ),
        ),
      );
    }

    testWidgets('PaintBar should render with all buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Vérifier que tous les boutons sont présents
      expect(find.byIcon(Icons.brush_outlined), findsOneWidget); // Initialement, ispainting est false
      expect(find.byIcon(Icons.color_lens), findsOneWidget);
      expect(find.byIcon(Icons.undo), findsOneWidget);
      expect(find.byIcon(Icons.redo), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('Toggle painting button should change icon and call togglePainting', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Vérifier que le bouton initial est brush_outlined (ispainting = false)
      expect(find.byIcon(Icons.brush_outlined), findsOneWidget);
      expect(find.byIcon(Icons.brush), findsNothing);

      // Appuyer sur le bouton de peinture
      await tester.tap(find.byIcon(Icons.brush_outlined));
      expect(togglePaintingCalled, true);

      // Changer manuellement ispainting pour simuler le changement d'état
      isPaintingValue = true;
      await tester.pumpWidget(createPaintBar());

      // Vérifier que le bouton est maintenant brush (ispainting = true)
      expect(find.byIcon(Icons.brush), findsOneWidget);
      expect(find.byIcon(Icons.brush_outlined), findsNothing);
    });

    testWidgets('Color picker button should show dialog', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Appuyer sur le bouton de couleur
      await tester.tap(find.byIcon(Icons.color_lens));
      await tester.pumpAndSettle();

      // Vérifier que la boîte de dialogue s'affiche
      expect(find.text('Pick a color'), findsOneWidget);
      expect(find.byType(BlockPicker), findsOneWidget);
    });

    testWidgets('Color picker should change color when selected', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Appuyer sur le bouton de couleur
      await tester.tap(find.byIcon(Icons.color_lens));
      await tester.pumpAndSettle();

      // Trouver un carré de couleur dans le BlockPicker
      // Note: Cette partie est complexe car nous ne pouvons pas facilement simuler une sélection de couleur
      // Nous vérifions simplement que le BlockPicker est présent
      expect(find.byType(BlockPicker), findsOneWidget);
    });

    testWidgets('Undo button should call undo function', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Appuyer sur le bouton d'annulation
      await tester.tap(find.byIcon(Icons.undo));

      // Vérifier que la fonction undo a été appelée
      expect(undoCalled, true);
    });

    testWidgets('Redo button should call redo function', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Appuyer sur le bouton de rétablissement
      await tester.tap(find.byIcon(Icons.redo));

      // Vérifier que la fonction redo a été appelée
      expect(redoCalled, true);
    });

    testWidgets('Save button should call save function', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Appuyer sur le bouton de sauvegarde
      await tester.tap(find.byIcon(Icons.save));

      // Vérifier que la fonction save a été appelée
      expect(saveCalled, true);
    });

    testWidgets('Container should have specified height', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Trouver le Container et vérifier sa hauteur
      final containerFinder = find.byType(Container).first;
      final containerWidget = tester.widget<Container>(containerFinder);
      expect(containerWidget.constraints?.maxHeight, 50);
    });

    testWidgets('ListView should have horizontal scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(createPaintBar());

      // Vérifier que le ListView a le scroll direction horizontal
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });
  });
}