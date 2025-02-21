import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/pages/my_games/game_editor/editor/object_component.dart';

import '../../../models/games/component_type.dart';

/// The page to add a component to an object.
class ObjectSelectParentPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final List<GameObject> objects;
  final ObjectComponent object;

  const ObjectSelectParentPage({super.key, required this.objects, required this.object});

  @override
  _ObjectSelectParentPageState createState() => _ObjectSelectParentPageState();
}

class _ObjectSelectParentPageState extends State<ObjectSelectParentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<GameObject> objects = widget.objects.where((element) => element.id != widget.object.gameObject.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Objects'),
      ),
      body: ListView(
        children: [
          for (var object in objects)
            ListTile(
              title: Text("${object.id}: ${object.name}"),
              onTap: () {
                widget.object.gameObject.parent = object;
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
