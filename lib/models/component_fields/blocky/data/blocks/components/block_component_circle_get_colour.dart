import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Circle Get Radius block.
final blockGetCircleColour = ToolboxBlock(type: "circle_get_colour");

/// Custom : Circle Get Radius block data.
final blockGetCircleColourJson = CustomBlock.fromJson(
    {
      "type": "circle_get_colour",
      "message0": "Get circle colour of object  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        }
      ],
      "output": "Colour",
      "colour": 230,
      "tooltip": "Get the colour of the circle component",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'getCircleColour(' + object + ')';
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