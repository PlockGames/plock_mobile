import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object Move block.
final blockObjectMove = ToolboxBlock(type: "object_move");

/// Custom : Object Move block data.
final blockObjectMoveJson = CustomBlock.fromJson(
    {
      "type": "object_move",
      "message0": "Move object %1  x = %2 y = %3 speed = %4",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        },
        {
          "type": "input_value",
          "name": "x",
          "check": "Number"
        },
        {
          "type": "input_value",
          "name": "y",
          "check": "Number"
        },
        {
          "type": "input_value",
          "name": "speed",
          "check": "Number"
        }
      ],
      "inputsInline": true,
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Move an object toward destination",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var x = generator.valueToCode(block, 'x', lua.Order.ATOMIC);
  var y = generator.valueToCode(block, 'y', lua.Order.ATOMIC);
  var speed = generator.valueToCode(block, 'speed', lua.Order.ATOMIC);
  var result = 'x = ' + x + ';';
  result += 'y = ' + y + ';';
  result += 'speed = ' + speed + ';';
  result += 'object = ' + object + ';';
  result += 'objectMove(object,x,y,speed);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');