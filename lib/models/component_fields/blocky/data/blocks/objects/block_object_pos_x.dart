import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object Pos X block.
final blockObjectPosX = ToolboxBlock(type: "object_pos_x");

/// Custom : Object Pos X block data.
final blockObjectPosXJson = CustomBlock.fromJson(
    {
      "type": "object_pos_x",
      "message0": "Change x position of %1 object %2 to  %3 %4",
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
          "name": "x",
          "check": "Number",
          "align": "RIGHT"
        }
      ],
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Change the x position of an object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var x = generator.valueToCode(block, 'x', lua.Order.ATOMIC);
  var result = 'x = ' + x + ';';
  result += 'object = ' + object + ';';
  result += 'changeObjectPosX(object,x);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');