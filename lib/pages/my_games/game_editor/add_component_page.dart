import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plock_mobile/data/ComponentList.dart';

import '../../../models/component_types/component_rect.dart';
import '../../../models/games/component_type.dart';

class AddComponentPage extends StatefulWidget {
  // A callback function to add a component to the game object
  final void Function(ComponentType) onAddComponent;

  AddComponentPage({super.key, required this.onAddComponent});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Component'),
      ),
      body: ListView(
        children: [
          for (var component in ComponentList.get().values)
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
