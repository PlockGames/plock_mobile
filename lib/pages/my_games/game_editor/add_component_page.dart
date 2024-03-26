import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/component_types/component_rect.dart';
import '../../../models/games/component_type.dart';

// The component list
Map<String, ComponentType> components = {
  'ComponentRect': ComponentRect(),
};

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