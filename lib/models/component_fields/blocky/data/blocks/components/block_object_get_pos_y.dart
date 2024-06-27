import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockGetObjectPosY = ToolboxBlock(type: "object_get_pos_y");

final blockGetObjectPosYJson = CustomBlock.fromJson(
    {
      "type": "object_get_pos_y",
      "message0": "Get pos y of object  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "String"
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Get the y position of the object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'getObjectPosY(' + object + ')';
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