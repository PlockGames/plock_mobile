import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockTextText = ToolboxBlock(type: "text_text");

final blockTextTextJson = CustomBlock.fromJson(
    {
      "type": "text_text",
      "message0": "Change text of %1 object %2 to  %3 %4",
      "args0": [
        {
          "type": "input_dummy"
        },
        {
          "type": "input_value",
          "name": "object",
          "check": "String",
          "align": "RIGHT"
        },
        {
          "type": "input_dummy"
        },
        {
          "type": "input_value",
          "name": "text",
          "check": "String",
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
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var text = generator.valueToCode(block, 'text', lua.Order.ATOMIC);
  var result = 'text = ' + text + ';';
  result += 'object = ' + object + ';';
  result += 'result[i] = \\\\"changeTextText \\\\" .. object .. \\\\" \\\\" .. text;';
  result += 'i = i+1;';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');