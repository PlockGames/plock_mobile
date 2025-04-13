import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PaintBar extends StatelessWidget {

  final Function() togglePainting;
  final Function(Color) setColor;
  final Function() undo;
  final Function() redo;
  final bool ispainting;
  final Function() save;

  const PaintBar({
    Key? key,
    required this.togglePainting,
    required this.setColor,
    required this.undo,
    required this.redo,
    required this.ispainting,
    required this.save,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (ispainting)
            IconButton(
              icon: const Icon(Icons.brush),
              onPressed: () {
                togglePainting();
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.brush_outlined),
              onPressed: () {
                togglePainting();
              },
            ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: Colors.red,
                        onColorChanged: (color) {
                          setColor(color);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              undo();
            },
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () {
              redo();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              save();
            },
          ),
        ],
      ),
    );
  }
}