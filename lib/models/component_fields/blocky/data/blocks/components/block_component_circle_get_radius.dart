import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Circle Get Radius block.
final blockGetCircleRadius = ToolboxBlock(type: "circle_get_radius");

/// Custom : Circle Get Radius block data.
final blockGetCircleRadiusJson = CustomBlock.fromJson(
    {
      "type": "circle_get_radius",
      "message0": "Get circle radius of object  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Get the radius of the circle component",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'getCircleRadius(' + object + ')';
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