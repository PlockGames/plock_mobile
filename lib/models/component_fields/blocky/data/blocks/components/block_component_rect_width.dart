import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockRectWidth = ToolboxBlock(type: "rect_width");

final blockRectWidthJson = CustomBlock.fromJson(
{
  "type": "rect_width",
  "message0": "Change rect width of %1 object %2 to  %3 %4",
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
      "name": "width",
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
  var width = generator.valueToCode(block, 'width', lua.Order.ATOMIC);
  return 'changeRectWidth(' + object + ', ' + width + ');\\n';
''').setFunctionDart(
'''
  var object = generator.valueToCode(block, 'object', dart.Order.ATOMIC);
  var width = generator.valueToCode(block, 'width', dart.Order.ATOMIC);
  return 'changeRectWidth(' + object + ', ' + width + ');\\n';
''').setFunctionJs('''
  var object = generator.valueToCode(block, 'object', javascript.Order.ATOMIC);
  var width = generator.valueToCode(block, 'width', javascript.Order.ATOMIC);
  return 'changeRectWidth(' + object + ', ' + width + ');\\n';
''').setFunctionPhp('''
  var object = generator.valueToCode(block, 'object', php.Order.ATOMIC);
  var width = generator.valueToCode(block, 'width', php.Order.ATOMIC);
  return 'changeRectWidth(' + object + ', ' + width + ');\\n';
''').setFunctionPython('''
  var object = generator.valueToCode(block, 'object', python.Order.ATOMIC);
  var width = generator.valueToCode(block, 'width', python.Order.ATOMIC);
  return 'changeRectWidth(' + object + ', ' + width + ');\\n';
''');