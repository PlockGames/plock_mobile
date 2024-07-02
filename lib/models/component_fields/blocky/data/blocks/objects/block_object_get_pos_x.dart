import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object Get Pos X block.
final blockGetObjectPosX = ToolboxBlock(type: "object_get_pos_x");

/// Custom : Object Get Pos X block data.
final blockGetObjectPosXJson = CustomBlock.fromJson(
    {
      "type": "object_get_pos_x",
      "message0": "Get pos x of object  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Get the x position of the object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'getObjectPosX(' + object + ')';
  return [result, lua.Order.NONE];
''').setFunctionDart('''
  return '';
''').setFunctionJs('''
  return '';
''').setFunctionPhp('''
  return '';
''').setFunctionPython('''
  return '';
''');