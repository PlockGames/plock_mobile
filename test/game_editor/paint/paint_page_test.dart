import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_bar.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas_painter.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_page.dart';

void main() {
  testWidgets('PaintPage UI renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PaintPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Paint'), findsOneWidget);
    expect(find.byType(PaintBar), findsOneWidget);
    expect(find.byType(PaintCanvas), findsOneWidget);
  });

  testWidgets('PaintBar buttons are interactive', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PaintPage()));

    final togglePaintButton = find.byIcon(Icons.brush);
    final colorButton = find.byIcon(Icons.color_lens);
    final undoButton = find.byIcon(Icons.undo);
    final redoButton = find.byIcon(Icons.redo);
    final saveButton = find.byIcon(Icons.save);

    await tester.tap(togglePaintButton);
    await tester.pump();
    await tester.tap(colorButton);
    await tester.pump();
    await tester.tap(undoButton);
    await tester.pump();
    await tester.tap(redoButton);
    await tester.pump();
    await tester.tap(saveButton);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}