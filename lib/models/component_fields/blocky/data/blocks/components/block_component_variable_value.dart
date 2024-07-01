import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Text Text block.
final blockVariableValue = ToolboxBlock(type: "variable_value");

/// Custom : Text Text block data.
final blockVariableValueJson = CustomBlock.fromJson(
    {
      "type": "variable_value",
      "message0": "Change variable %1 of object %2 to %3",
      "args0": [
        {
          "type": "input_value",
          "name": "name",
          "check": "String",
          "align": "RIGHT"
        },
        {
          "type": "input_value",
          "name": "object",
          "check": "Number",
          "align": "RIGHT"
        },
        {
          "type": "input_value",
          "name": "value",
          "align": "RIGHT"
        }
      ],
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Change a text component text",
      "helpUrl": ""
    }
).setFunctionLua('''
  var name = generator.valueToCode(block, 'name', lua.Order.ATOMIC);
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var value = generator.valueToCode(block, 'value', lua.Order.ATOMIC);
  var result = 'changeVariableValue(' + object+ ', ' + name + ', ' + value + ');';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');