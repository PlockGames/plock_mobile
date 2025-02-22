import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart' as rendering;
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_bar.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas.dart';
import 'package:plock_mobile/pages/my_games/game_editor/paint/paint_canvas_painter.dart';

class PaintPage extends StatefulWidget {
  PaintController controller = PaintController();

  PaintPage({super.key});

  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  @override
  void initState() {
    super.initState();
  }

  void togglePainting() {
    setState(() {
      widget.controller.isPainting = !widget.controller.isPainting;
    });
  }

  void setColor(Color color) {
    setState(() {
      widget.controller.color = color;
    });
  }

  void undo() {
    setState(() {
      widget.controller.undo();
    });
  }

  void redo() {
    setState(() {
      widget.controller.redo();
    });
  }

  void save() async {
    var finalImage = createImageFromStrokes(16, 16, widget.controller.strokes);
    (await finalImage.toImage(16, 16)).toByteData(format: ImageByteFormat.png).then((byteData) {
      final buffer = byteData!.buffer.asUint8List();
      Gal.putImageBytes(buffer);
    });
  }

  Picture createImageFromStrokes(int width, int height, List<Stroke> strokes) {
    var recorder = PictureRecorder();
    var canvas = rendering.Canvas(recorder);
    var paint = Paint();
    List<List<Color>> pixels = List.generate(width, (index) => List.filled(height, Colors.transparent));

    paint.color = Colors.transparent;
    for (var stroke in strokes) {
      paint.color = stroke.color;
      for (var i = 0; i < stroke.points.length - 1; i++) {
        var p = stroke.points[i];
        if (p.dx < 0 || p.dy < 0 || p.dx >= width || p.dy >= height) {
          continue;
        }
        pixels[p.dx.toInt()][p.dy.toInt()] = paint.color;
      }
    }

    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        paint.color = pixels[x][y];
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
    return recorder.endRecording();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint'),
      ),
      body: Column(
        children: [
          PaintBar(
            togglePainting: togglePainting,
            setColor: setColor,
            undo: undo,
            redo: redo,
            ispainting: widget.controller.isPainting,
            save: save,
          ),
          SizedBox.fromSize(size: const Size(0, 40)),
          PaintCanvas(
              controller: widget.controller,
              width: 16,
              height: 16
          ),
        ],
      ),
    );
  }
}