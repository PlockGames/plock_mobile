import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

class ComponentFieldDropDown extends ComponentField {
String _value;
Map<String, String> _options;
DropDownField? field;

ComponentFieldDropDown({
    required String value,
    required Map<String, String> options,
    onUpdate,
  }) : _value = value, _options = options {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldDropDown';

  @override
  Widget getField(String name) {
    field ??= DropDownField(name: name, initialValue: _value, options: _options, onUpdate: onUpdate, updateValue: updateValue);
    return field!;
  }

  @override
  ComponentFieldDropDown instance() {
    return ComponentFieldDropDown(value: _value, options: _options ,onUpdate: onUpdate);
  }

  @override
  String get value => _value;

  void updateValue(String newValue) {
    _value = newValue;
  }

  @override
  set value(dynamic value) {
    _value = value;
  }

  @override
  String toJson() {
    return "\"$_value\"";
  }
}

class DropDownField extends StatefulWidget {
  final String name;
  final Map<String, String> options;
  String _value = "";
  var onUpdate;
  var updateValue;

  DropDownField({required this.name, required initialValue, required this.options, this.onUpdate, this.updateValue}) : _value = initialValue;

  String get value => _value;

  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row (
        children: [
          Expanded(
              child: DropdownButton(
                value: widget._value,
                items: widget.options.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(widget.options[key]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget._value = value.toString();
                  });
                  widget.updateValue(value.toString());
                  widget.onUpdate();
                },
              )
          )
        ]
    );
  }
}