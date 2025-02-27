import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_scene_component.dart';

import '../../../models/games/component_type.dart';
import 'editor/editor_canvas.dart';
import 'editor/object_component.dart';

/// The page to add a component to an object.
class ObjectsPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final List<ObjectComponent> objects;
  final Function(ObjectComponent, List<GameObject>, EditorCanvas canvas) openEditor;
  final Function(ObjectComponent, EditorCanvas) removeObject;
  final EditorCanvas canvas;

  const ObjectsPage({super.key, required this.objects, required this.openEditor, required this.canvas, required this.removeObject});

  @override
  _AddComponentPageState createState() => _AddComponentPageState();
}

class _AddComponentPageState extends State<ObjectsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objects'),
      ),
      body: ListView(
        children: [
          for (var object in widget.objects)
            ListTile(
              title: Row(
                children: [
                  Text(object.getGameObject().name),
                  const Spacer(),
                  IconButton(
                    icon: object.getGameObject().enabled ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        object.getGameObject().enabled = !object.getGameObject().enabled;
                        object.updateDisplay();
                      });
                    },
                  ),
                  IconButton(
                    icon: object.getGameObject().visible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        object.getGameObject().visible = !object.getGameObject().visible;
                        object.updateDisplay();
                      });
                    },
                  ),
                  IconButton(
                    icon: object.getGameObject().locked ? const Icon(Icons.lock) : const Icon(Icons.lock_open),
                    onPressed: () {
                      setState(() {
                        object.getGameObject().locked = !object.getGameObject().locked;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        widget.removeObject(object, widget.canvas);
                        widget.objects.remove(object);

                      });
                    },
                  ),
                ],
              ),
              onTap: () {
                List<GameObject> objects = widget.objects.map((e) => e.getGameObject()).toList();
                widget.openEditor(object, objects, widget.canvas);
              },
            ),
        ],
      ),
    );
  }
}
