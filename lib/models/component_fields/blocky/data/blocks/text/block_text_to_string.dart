import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockTextToString = ToolboxBlock(type: "int_to_string");

final blockTextToStringJson = CustomBlock.fromJson(
    {
      "type": "int_to_string",
      "message0": "Text from number %1",
      "args0": [
        {
          "type": "input_value",
          "name": "number",
          "check": "Number"
        }
      ],
      "output": "String",
      "colour": 230,
      "tooltip": "Convert a number to text",
      "helpUrl": ""
    }
).setFunctionLua('''
  var number = generator.valueToCode(block, 'number', lua.Order.ATOMIC);
  var result = 'tostring(' + number + ')';
  return [result, lua.Order.NONE];
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');