import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Component Event Trigger
final blockEventTrigger = ToolboxBlock(type: "event_trigger");

/// Custom : Component Event Trigger block data.
final blockEventTriggerJson = CustomBlock.fromJson(
    {
      "type": "event_trigger",
      "message0": "Change event %1 trigger %2 %3 to object %4",
      "args0": [
        {
          "type": "input_value",
          "name": "name",
          "check": "String"
        },
        {
          "type": "field_dropdown",
          "name": "trigger",
          "options": [
            [
              "on start",
              "ON_START"
            ],
            [
              "on update",
              "ON_UPDATE"
            ],
            [
              "on_tap",
              "ON_TAP"
            ],
          ]
        },
        {
          "type": "input_dummy"
        },
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        }
      ],
      "inputsInline": false,
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Add a component to an object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var name = generator.valueToCode(block, 'name', lua.Order.ATOMIC);
  var trigger = block.getFieldValue('trigger');
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'changeEventTrigger(\\\\"' + name + '\\\\", \\\\"' + trigger + '\\\\", ' + object + ');';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');