import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockObjectPosY = ToolboxBlock(type: "object_pos_y");

final blockObjectPosYJson = CustomBlock.fromJson(
    {
      "type": "object_pos_y",
      "message0": "Change y position of %1 object %2 to  %3 %4",
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
          "name": "y",
          "check": "Number",
          "align": "RIGHT"
        }
      ],
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Change the y position of an object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var y = generator.valueToCode(block, 'y', lua.Order.ATOMIC);
  var result = 'y = ' + y + ';';
  result += 'object = ' + object + ';';
  result += 'result[i] = \\\\"changeObjectPosY \\\\" .. object .. \\\\" \\\\" .. y;';
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