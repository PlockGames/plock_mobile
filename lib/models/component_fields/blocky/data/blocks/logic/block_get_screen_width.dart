import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockGetScreenWidth = ToolboxBlock(type: "screen_get_width");

final blockGetScreenWidthJson = CustomBlock.fromJson(
    {
      "type": "screen_get_width",
      "message0": "Get screen width %1",
      "args0": [
        {
          "type": "input_dummy",
        }
      ],
      "output": "Number",
      "colour": 230,
      "tooltip": "Get screen width",
      "helpUrl": ""
    }
).setFunctionLua('''
  var result = 'getScreenWidth()';
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