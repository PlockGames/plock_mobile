import 'package:flutter/material.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';

class SpriteEditorPage extends StatefulWidget {
  final PlockSpriteAnimation sprite;
  final Function? onUpdate;

  SpriteEditorPage({required this.sprite, required this.onUpdate});

  @override
  _SpriteEditorPageState createState() => _SpriteEditorPageState();
}

class _SpriteEditorPageState extends State<SpriteEditorPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: widget.sprite.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sprite Editor'),
      ),
      body: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  widget.sprite.name = value;
                  if (widget.onUpdate != null) {
                    widget.onUpdate!();
                  }
                },
              ),
              for (int i = 0; i < widget.sprite.images.length; i++)
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child:
                        TextField(
                          controller: TextEditingController(text: widget.sprite.images[i]),
                          decoration: const InputDecoration(
                            labelText: 'Image',
                          ),
                          onChanged: (value) {
                            widget.sprite.images[i] = value;
                            if (widget.onUpdate != null) {
                              widget.onUpdate!();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.sprite.images.removeAt(i);
                            if (widget.onUpdate != null) {
                              widget.onUpdate!();
                            };
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.sprite.images.add('new image');
                    if (widget.onUpdate != null) {
                      widget.onUpdate!();
                    }
                  });
                },
                child: Icon(Icons.add),
              ),
            ],
          )
        );
  }
}