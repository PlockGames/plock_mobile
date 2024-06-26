import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockRectHeight = ToolboxBlock(type: "rect_height");

final blockRectHeightJson = CustomBlock.fromJson(
{
  "type": "rect_height",
  "message0": "Change rect height of %1 object %2 to  %3 %4",
  "args0": [
    {
      "type": "input_dummy"
    },
    {
      "type": "input_value",
      "name": "object",
      "check": "String",
      "align": "RIGHT"
    },
    {
      "type": "input_dummy"
    },
    {
      "type": "input_value",
      "name": "height",
      "check": "Number",
      "align": "RIGHT"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 230,
  "tooltip": "Change a rect component size",
  "helpUrl": ""
}
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var height = generator.valueToCode(block, 'height', lua.Order.ATOMIC);
  return 'result[i] = \\\\"changeRectHeight ' + object + ' ' + height + '\\\\"; i = i+1';
''').setFunctionDart('''
  var object = generator.valueToCode(block, 'object', dart.Order.ATOMIC);
  var height = generator.valueToCode(block, 'height', dart.Order.ATOMIC);
  return 'result = \\\\"changeRectHeight ' + object + ' ' + height + '\\\\"';
''').setFunctionJs('''
  var object = generator.valueToCode(block, 'object', javascript.Order.ATOMIC);
  var height = generator.valueToCode(block, 'height', javascript.Order.ATOMIC);
  return 'result = \\\\"changeRectHeight ' + object + ' ' + height + '\\\\"';
''').setFunctionPhp('''
  var object = generator.valueToCode(block, 'object', php.Order.ATOMIC);
  var height = generator.valueToCode(block, 'height', php.Order.ATOMIC);
  return 'result = \\\\"changeRectHeight ' + object + ' ' + height + '\\\\"';
''').setFunctionPython('''
  var object = generator.valueToCode(block, 'object', python.Order.ATOMIC);
  var height = generator.valueToCode(block, 'height', python.Order.ATOMIC);
  return 'result = \\\\"changeRectHeight ' + object + ' ' + height + '\\\\"';
''');