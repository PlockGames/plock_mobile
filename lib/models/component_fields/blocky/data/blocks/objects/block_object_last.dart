import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object this block.
final blockObjectLast = ToolboxBlock(type: "object_last");

/// Custom : Object this block data.
final blockObjectLastJson = CustomBlock.fromJson(
    {
      "type": "object_last",
      "message0": "last object spawned",
      "inputsInline": true,
      "output": "Number",
      "colour": 230,
      "tooltip": "Return the last object spawned id",
      "helpUrl": ""
    }
).setFunctionLua('''
  var result = 'lastObject()';
  return [result, lua.Order.NONE];
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');