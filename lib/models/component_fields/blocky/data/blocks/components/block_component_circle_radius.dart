import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Circle Radius block.
final blockCircleRadius = ToolboxBlock(type: "circleRadius");

/// Custom : Circle Radius block data.
final blockCircleRadiusJson = CustomBlock.fromJson(
{
  "type": "circleRadius",
  "message0": "Change circle radius of %1 object %2 to  %3 %4",
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
      "name": "radius",
      "check": "Number",
      "align": "RIGHT"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Change a circle component radius",
  "helpUrl": ""
}
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var radius = generator.valueToCode(block, 'radius', lua.Order.ATOMIC);
  var result = 'radius = ' + radius + ';';
  result += 'object = ' + object + ';';
  result += 'changeCircleRadius(object,radius);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');