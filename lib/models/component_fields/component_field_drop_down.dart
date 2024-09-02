import 'package:flutter/material.dart';
import 'package:plock_mobile/models/games/component_field.dart';

/// A field that contain a dropdown value.
class ComponentFieldDropDown extends ComponentField {

  /// The value of the field.
  String _value;

  /// The options of the dropdown.
  Map<String, String> _options;

  /// The dropdown widget.
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
  Widget getField(String name, bool debug) {
    field ??= DropDownField(initialValue: _value, options: _options, onUpdate: onUpdate, updateValue: updateValue);
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

  @override
  void updateFromJson(dynamic jsonVal) {
    _value = jsonVal as String;
  }
}

/// The dropdown widget.
class DropDownField extends StatefulWidget {

  /// The options of the dropdown.
  final Map<String, String> options;

  /// The current value of the dropdown.
  String _value = "";

  /// The callback executed when the value is updated.
  Function? onUpdate;
  /// The callback to update the value.
  Function? updateValue;

  DropDownField({required initialValue, required this.options, this.onUpdate, this.updateValue}) : _value = initialValue;

  /// The value of the field.
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
                  if (widget.updateValue != null) {
                    widget.updateValue!(value.toString());
                  }
                  if (widget.onUpdate != null) {
                    widget.onUpdate!();
                  }
                },
              )
          )
        ]
    );
  }
}