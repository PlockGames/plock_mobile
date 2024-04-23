import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/games/component_type.dart';

class EditComponentPage extends StatefulWidget {
  final ComponentType component;

  EditComponentPage({super.key, required this.component});

  @override
  _EditComponentPageState createState() => _EditComponentPageState();
}

class _EditComponentPageState extends State<EditComponentPage> {
  late ComponentType _component;

  @override
  void initState() {
    super.initState();
    _component = widget.component;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${_component.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
              for (var pair in _component.fields.entries)
                pair.value.getField(pair.key)
            ],
          ),
      ),
    );
  }
}