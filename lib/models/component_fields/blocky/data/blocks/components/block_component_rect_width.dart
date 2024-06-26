import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockRectWidth = ToolboxBlock(type: "rect_width");

final blockRectWidthJson = CustomBlock.fromJson(
{
  "type": "rect_width",
  "message0": "Change rect width of %1 object %2 to  %3 %4",
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
      "name": "width",
      "check": "Number",
      "align": "RIGHT"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Change a rect component size",
  "helpUrl": ""
}
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var width = generator.valueToCode(block, 'width', lua.Order.ATOMIC);
  var result = 'width = ' + width + ';';
  result += 'object = ' + object + ';';
  result += 'result[i] = \\\\"changeRectWidth \\\\" .. object .. \\\\" \\\\" .. tostring(width);';
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