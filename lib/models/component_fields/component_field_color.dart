import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:plock_mobile/models/games/component_field.dart';

/// A field that contain a dropdown value.
class ComponentFieldColour extends ComponentField {

  /// The value of the field.
  Color _value;

  /// The color widget.
  ColourField? field;

  ComponentFieldColour({
    required Color value,
    onUpdate,
  }) : _value = value {
    this.onUpdate = onUpdate;
  }

  @override
  String get type => 'ComponentFieldColor';

  @override
  Widget getField(String name) {
    field ??= ColourField(initialValue: _value, onUpdate: onUpdate, updateValue: updateValue);
    return field!;
  }

  @override
  ComponentFieldColour instance() {
    return ComponentFieldColour(value: _value, onUpdate: onUpdate);
  }

  @override
  Color get value => _value;

  void updateValue(Color newValue) {
    _value = newValue;
  }

  @override
  set value(dynamic value) {
    _value = value;
  }

  @override
  String toJson() {
    String hex = _value.toHexString();
    return "\"$hex\"";
  }

  @override
  void updateFromJson(dynamic jsonVal) {
    String hex = jsonVal as String;
    _value = Color(int.parse(hex, radix: 16));
  }
}

/// The dropdown widget.
class ColourField extends StatefulWidget {

  /// The current value of the dropdown.
  Color _value = Color(0xff443a49);

  /// The callback executed when the value is updated.
  Function? onUpdate;
  /// The callback to update the value.
  Function? updateValue;

  ColourField({required initialValue, this.onUpdate, this.updateValue}) : _value = initialValue;

  /// The value of the field.
  Color get value => _value;

  @override
  _ColourFieldState createState() => _ColourFieldState();
}

class _ColourFieldState extends State<ColourField> {
  Color pickerColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row (
        children: [
          Expanded(
              child: Row(
                children: [
                  Text('Color'),
                  Expanded(child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: (color) {
                              pickerColor = color;
                            },
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              setState(() {
                                widget.updateValue!(pickerColor);
                                widget.onUpdate!();
                                widget._value = pickerColor;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.value,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(

                        color: Color(0xffffffff),
                        width: 1,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ))
                    ]
              )
          )
        ]
    );
  }
}