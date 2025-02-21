import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

import '../../../models/games/component_type.dart';

/// The page to add a component to an object.
class ObjectsPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final List<ObjectComponent> objects;
  final Function(ObjectComponent) openEditor;

  const ObjectsPage({super.key, required this.objects, required this.openEditor});

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
              title: Text(object.gameObject.name),
              onTap: () {
                widget.openEditor(object);
              },
            ),
        ],
      ),
    );
  }
}
