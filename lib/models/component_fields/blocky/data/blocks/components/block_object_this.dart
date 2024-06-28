import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object this block.
final blockObjectThis = ToolboxBlock(type: "object_this");

/// Custom : Object this block data.
final blockObjectThisJson = CustomBlock.fromJson(
    {
      "type": "object_this",
      "message0": "This object",
      "inputsInline": true,
      "output": "Number",
      "colour": 230,
      "tooltip": "Return the object id",
      "helpUrl": ""
    }
).setFunctionLua('''
  var result = 'thisObject()';
  return [result, lua.Order.NONE];
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');