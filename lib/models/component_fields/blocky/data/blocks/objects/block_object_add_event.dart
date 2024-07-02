import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object Pos X block.
final blockObjectAddEvent = ToolboxBlock(type: "object_add_event");

/// Custom : Object Pos X block data.
final blockObjectAddEventJson = CustomBlock.fromJson(
    {
      "type": "object_add_event",
      "message0": "Add event to %1 object %2 with name %3 %4",
      "args0": [
        {
          "type": "input_dummy"
        },
        {
          "type": "input_value",
          "name": "object",
          "check": "Number",
          "align": "RIGHT"
        },
        {
          "type": "input_dummy"
        },
        {
          "type": "input_value",
          "name": "name",
          "check": "String",
          "align": "RIGHT"
        }
      ],
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Add an event to an object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var name = generator.valueToCode(block, 'name', lua.Order.ATOMIC);
  var result = 'name = \\\\"' + name + '\\\\";';
  result += 'object = ' + object + ';';
  result += 'addEventToObject(object,name);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');