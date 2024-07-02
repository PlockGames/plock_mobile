import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Circle Radius block.
final blockCircleColour = ToolboxBlock(type: "circle_colour");

/// Custom : Circle Radius block data.
final blockCircleColourJson = CustomBlock.fromJson(
{
  "type": "circle_colour",
  "message0": "Change circle color of %1 object %2 to  %3 %4",
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
      "name": "colour",
      "check": "Colour",
      "align": "RIGHT"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Change a circle component color",
  "helpUrl": ""
}
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var colour = generator.valueToCode(block, 'colour', lua.Order.ATOMIC);
  var result = 'colour = ' + colour + ';';
  result += 'object = ' + object + ';';
  result += 'changeCircleColour(object,colour);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');