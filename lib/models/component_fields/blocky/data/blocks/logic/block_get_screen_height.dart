import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Get Screen Height block.
final blockGetScreenHeight = ToolboxBlock(type: "screen_get_height");

/// Custom : Get Screen Height block data.
final blockGetScreenHeightJson = CustomBlock.fromJson(
    {
      "type": "screen_get_height",
      "message0": "Get screen height %1",
      "args0": [
        {
          "type": "input_dummy",
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Get screen height",
      "helpUrl": ""
    }
).setFunctionLua('''
  var result = 'getScreenHeight()';
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