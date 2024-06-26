import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockGetRectWidth = ToolboxBlock(type: "rect_get_width");

final blockGetRectWidthJson = CustomBlock.fromJson(
    {
      "type": "rect_get_width",
      "message0": "Get rect width of object  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "String"
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Get the width of the rect component",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  object = object.slice(1, -1);
  var result = 'game[\\\\"' + object + '\\\\"][\\\\"ComponentRect\\\\"][\\\\"width\\\\"]';
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