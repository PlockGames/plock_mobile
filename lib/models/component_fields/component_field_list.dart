import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

import '../games/media.dart';

/// A Field that contain a Text value
class ComponentFieldList extends ComponentField {

  /// The value of the field
  List<String> _value;

  ListField? field;

  ComponentFieldList({
    required List<String> value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldList';

  @override
  Widget getField(String name, bool debug, List<Media> medias) {
    field ??= ListField(options: _value, onUpdate: (text) {
      _value = _value;
      if (onUpdate != null) {
        onUpdate!();
      }
    }, updateValue: () {
      if (onUpdate != null) {
        onUpdate!();
      }
    });
    return field!;
  }

  @override
  ComponentFieldList instance() {
    return ComponentFieldList(value: _value, onUpdate: onUpdate);
  }

  @override
  List<String> get value => _value;

  @override
  set value(dynamic value) {
    _value = value;
  }

  @override
  String toJson() {
    return "\"$_value\"";
  }

  @override
  void updateFromJson(dynamic jsonVal) {
    _value = jsonVal as List<String>;
  }

}

/// The list widget.
class ListField extends StatefulWidget {

  /// The options of the list.
  final List<String> options;

  /// The callback to update the value.
  final Function(String) onUpdate;

  /// The callback to update the value.
  final Function() updateValue;

  ListField({
    required this.options,
    required this.onUpdate,
    required this.updateValue,
  });

  @override
  _ListFieldState createState() => _ListFieldState();
}

class _ListFieldState extends State<ListField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.options.length; i++)
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Value",
                  ),
                  controller: TextEditingController(text: widget.options[i]),
                  onChanged: (text) {
                    widget.options[i] = text;
                    widget.onUpdate(text);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.options.removeAt(i);
                    widget.updateValue();
                  });
                },
                child: Text("Remove"),
              ),
            ],
          ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.options.add("");
              widget.updateValue();
            });
          },
          child: Text("Add Value"),
        ),
      ],
    );
  }
}
