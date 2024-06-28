import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Rect Get Height block.
final blockGetRectHeight = ToolboxBlock(type: "rect_get_height");

/// Custom : Rect Get Height block data.
final blockGetRectHeightJson = CustomBlock.fromJson(
    {
      "type": "rect_get_height",
      "message0": "Get rect height of object  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Get the height of the rect component",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'getRectHeight(' + object + ')';
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