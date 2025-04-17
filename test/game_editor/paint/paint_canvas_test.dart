import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas_painter.dart';

// Mock pour PaintController
class MockPaintController extends PaintController {
  @override
  Color color = Colors.red;

  @override
  List<Stroke> strokes = [];

  @override
  List<Stroke> redoStack = [];

  int addStrokeCalled = 0;

  @override
  void addStroke(Stroke stroke) {
    addStrokeCalled++;
    strokes.add(stroke);
  }
}

void main() {
  group('PaintCanvas Widget Tests', () {
    late MockPaintController controller;

    setUp(() {
      controller = MockPaintController();
    });

    testWidgets('PaintCanvas should render with correct dimensions', (WidgetTester tester) async {
      const int width = 10;
      const int height = 8;
      final expectedWidth = width * 20.0;
      final expectedHeight = height * 20.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PaintCanvas(
                controller: controller,
                width: width,
                height: height,
              ),
            ),
          ),
        ),
      );

      // Trouver le Container principal et vérifier ses contraintes
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      // Mesurer la taille du widget rendu
      final Size containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, expectedWidth);
      expect(containerSize.height, expectedHeight);

      // Vérifier la couleur du container
      final container = tester.widget<Container>(containerFinder);
      expect(container.color, Colors.white);
    });

    testWidgets('PaintCanvas should render CustomPaint and RepaintBoundary', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PaintCanvas(
                controller: controller,
                width: 10,
                height: 8,
              ),
            ),
          ),
        ),
      );

      // Vérifier que CustomPaint est rendu (il peut être dans un widget enfant)
      expect(find.descendant(
          of: find.byType(PaintCanvas),
          matching: find.byType(CustomPaint)
      ), findsOneWidget);

      // Vérifier que RepaintBoundary est rendu (il peut être dans un widget enfant)
      expect(find.descendant(
          of: find.byType(PaintCanvas),
          matching: find.byType(RepaintBoundary)
      ), findsOneWidget);
    });

    testWidgets('PaintCanvas should handle pan start correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PaintCanvas(
                controller: controller,
                width: 10,
                height: 8,
              ),
            ),
          ),
        ),
      );

      // Trouver le GestureDetector
      final gestureDetectorFinder = find.descendant(
          of: find.byType(PaintCanvas),
          matching: find.byType(GestureDetector)
      );
      expect(gestureDetectorFinder, findsOneWidget);

      // Obtenir la position au centre du canvas
      final Offset center = tester.getCenter(gestureDetectorFinder);

      // Simuler un mouvement pour déclencher onPanStart
      final testGesture = await tester.startGesture(center);
      await tester.pump(); // Permettre au widget de traiter l'événement

      // Faire un petit mouvement pour s'assurer que onPanUpdate est appelé
      await testGesture.moveBy(const Offset(10, 10));
      await tester.pump();

      // Terminer le geste
      await testGesture.up();
      await tester.pump();

      // Vérifier que addStroke a été appelé
      expect(controller.addStrokeCalled, 1);

      // Vérifier qu'un nouveau trait a été ajouté avec au moins un point
      expect(controller.strokes.length, 1);
      expect(controller.strokes[0].points, isNotEmpty);

      // Vérifier que la couleur du trait est la même que celle du contrôleur
      expect(controller.strokes[0].color, controller.color);
    });

    testWidgets('PaintCanvas should handle multiple strokes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PaintCanvas(
                controller: controller,
                width: 10,
                height: 8,
              ),
            ),
          ),
        ),
      );

      // Trouver le GestureDetector
      final gestureDetectorFinder = find.descendant(
          of: find.byType(PaintCanvas),
          matching: find.byType(GestureDetector)
      );
      final Offset center = tester.getCenter(gestureDetectorFinder);

      // Premier trait
      final testGesture1 = await tester.startGesture(center);
      await tester.pump();
      await testGesture1.moveBy(const Offset(20, 20));
      await tester.pump();
      await testGesture1.up();
      await tester.pump();

      // Deuxième trait (commençant à un autre endroit)
      final testGesture2 = await tester.startGesture(center.translate(40, 0));
      await tester.pump();
      await testGesture2.moveBy(const Offset(20, 20));
      await tester.pump();
      await testGesture2.up();
      await tester.pump();

      // Vérifier que deux traits ont été ajoutés
      expect(controller.strokes.length, 2);

      // Vérifier que chaque trait a au moins un point
      expect(controller.strokes[0].points, isNotEmpty);
      expect(controller.strokes[1].points, isNotEmpty);

      // Vérifier que les traits ont des points de départ différents
      expect(
          controller.strokes[0].points[0],
          isNot(equals(controller.strokes[1].points[0]))
      );
    });
  });
}