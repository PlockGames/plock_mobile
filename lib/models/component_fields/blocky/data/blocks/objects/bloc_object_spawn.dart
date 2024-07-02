import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object Pos X block.
final blockObjectSpawn = ToolboxBlock(type: "object_spawn");

/// Custom : Object Pos X block data.
final blockObjectSpawnJson = CustomBlock.fromJson(
    {
      "type": "object_spawn",
      "message0": "Spawn object with name %1",
      "args0": [
        {
          "type": "input_value",
          "name": "name",
          "check": "String"
        }
      ],
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Spawn an object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var name = generator.valueToCode(block, 'name', lua.Order.ATOMIC);
  var result = 'name = ' + name + ';';
  result += 'spawnObject(name);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');