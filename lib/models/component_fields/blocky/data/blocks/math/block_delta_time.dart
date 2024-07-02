import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object this block.
final blockDeltaTime = ToolboxBlock(type: "delta_time");

/// Custom : Object this block data.
final blockDeltaTimeJson = CustomBlock.fromJson(
    {
      "type": "delta_time",
      "message0": "delta time",
      "inputsInline": true,
      "output": "Number",
      "colour": 230,
      "tooltip": "Return the delta time",
      "helpUrl": ""
    }
).setFunctionLua('''
  var result = 'deltaTime()';
  return [result, lua.Order.NONE];
''').setFunctionDart('''return ['deltaTime()', Blockly.JavaScript.ORDER_NONE];''')
    .setFunctionJs('''
  return ['deltaTime()', Blockly.JavaScript.ORDER_NONE];
''').setFunctionPhp('''
  return ['deltaTime()', Blockly.JavaScript.ORDER_NONE];
''').setFunctionPython('''
  return ['deltaTime()', Blockly.JavaScript.ORDER_NONE];
''');