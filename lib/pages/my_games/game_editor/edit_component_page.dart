import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/games/component_type.dart';

/// The page to edit a component.
class EditComponentPage extends StatefulWidget {

  /// The component to edit.
  final ComponentType component;

  const EditComponentPage({super.key, required this.component});

  @override
  _EditComponentPageState createState() => _EditComponentPageState();
}

class _EditComponentPageState extends State<EditComponentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.component.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
              for (var pair in widget.component.fields.entries)
                pair.value.getField(pair.key)
            ],
          ),
      ),
    );
  }
}
