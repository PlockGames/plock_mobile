import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Wait block.
final blockWait = ToolboxBlock(type: "wait");

/// Custom : Wait block data.
final blockWaitJson = CustomBlock.fromJson(
    {
      "type": "wait",
      "message0": "wait for %1",
      "args0": [
        {
          "type": "input_value",
          "name": "time",
          "check": "Number"
        }
      ],
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "wait",
      "helpUrl": ""
    }
).setFunctionLua('''
  var time = generator.valueToCode(block, 'time', lua.Order.ATOMIC);
  var result = 'time = ' + time + ';';
  result += 'wait(time);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');