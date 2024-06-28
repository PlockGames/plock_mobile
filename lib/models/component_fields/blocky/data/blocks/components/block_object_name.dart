import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object this block.
final blockObjectName = ToolboxBlock(type: "object_name");

/// Custom : Object this block data.
final blockObjectNameJson = CustomBlock.fromJson(
    {
      "type": "object_name",
      "message0": "get object by name  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "String"
        }
      ],
      "inputsInline": true,
      "output": "Number",
      "colour": 230,
      "tooltip": "Return the object id",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'getObjectByName(' + object + ')';
  return [result, lua.Order.NONE];
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');