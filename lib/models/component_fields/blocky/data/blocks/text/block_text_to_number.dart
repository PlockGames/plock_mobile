import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : String to int block
final blockTextToNumber = ToolboxBlock(type: "string_to_int");

/// Custom : String to int block data
final blockTextToNumberJson = CustomBlock.fromJson(
    {
      "type": "string_to_int",
      "message0": "number from text %1",
      "args0": [
        {
          "type": "input_value",
          "name": "text",
          "check": "String"
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Convert a text to number",
      "helpUrl": ""
    }
).setFunctionLua('''
  var text = generator.valueToCode(block, 'text', lua.Order.ATOMIC);
  var result = 'tonumber(' + text + ')';
  return [result, lua.Order.NONE];
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');