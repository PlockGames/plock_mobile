import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas_painter.dart';

class PaintCanvas extends StatefulWidget {
  final double pixelSize = 20;
  final PaintController controller;
  final int width;
  final int height;

  PaintCanvas({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
  });

  @override
  _PaintCanvasState createState() => _PaintCanvasState();

}

class _PaintCanvasState extends State<PaintCanvas> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double pixelWidth = widget.width * widget.pixelSize;
    double pixelHeight = widget.height * widget.pixelSize;

    GestureDetector buildGestureDetector(RepaintBoundary boundary) {

      return GestureDetector(
        child: boundary,
        onPanStart: (details) {
            widget.controller.addStroke(Stroke()
              ..points = List.empty(growable: true)
              ..color = widget.controller.color
            );
            int x = (details.localPosition.dx ~/ widget.pixelSize);
            int y = (details.localPosition.dy ~/ widget.pixelSize);

            widget.controller.strokes.last.points.add(Offset(
              x.toDouble(),
              y.toDouble(),
            ));
          },
        onPanUpdate: (details) {
            setState(() {
              int x = (details.localPosition.dx ~/ widget.pixelSize);
              int y = (details.localPosition.dy ~/ widget.pixelSize);

              widget.controller.strokes.last.points.add(Offset(
                x.toDouble(),
                y.toDouble(),
              ));

            });
          },
        onPanEnd: (details) {
            setState(() {

            });
        },
      );
    }

    return Container(
      color: Colors.white,
      width: pixelWidth,
      height: pixelHeight,
      child: buildGestureDetector(RepaintBoundary(
        child: CustomPaint(
        painter: PaintCanvasPainter(widget.controller, widget.width, widget.height, 20)
      )
      )
    ));
  }
}