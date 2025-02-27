import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/data/ComponentList.dart';

import '../../../models/games/component_type.dart';
import 'editor/editor_canvas.dart';

/// The page to add a component to an object.
class AddComponentPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final void Function(ComponentType) onAddComponent;

  /// the canvas of the object.
  final EditorCanvas canvas;

  const AddComponentPage({super.key, required this.onAddComponent, required this.canvas});

  @override
  _AddComponentPageState createState() => _AddComponentPageState();
}

class _AddComponentPageState extends State<AddComponentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, ComponentType> components;
    if (widget.canvas == EditorCanvas.ui) {
      components = ComponentList.getUi();
    } else {
      components = ComponentList.getScene();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Component'),
      ),
      body: ListView(
        children: [
          for (var component in components.values)
            ListTile(
              title: Text(component.name),
              onTap: () {
                widget.onAddComponent(component);
                Navigator.of(context).pop(component);
              },
            ),
        ],
      ),
    );
  }
}
