import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object Pos X block.
final blockObjectAddComponent = ToolboxBlock(type: "object_add_component");

/// Custom : Object Pos X block data.
final blockObjectAddComponentJson = CustomBlock.fromJson(
    {
      "type": "object_add_component",
      "message0": "add component %1 %2 to object %3",
      "args0": [
        {
          "type": "field_dropdown",
          "name": "component",
          "options": [
            [
              "rectangle",
              "ComponentRect"
            ],
            [
              "circle",
              "ComponentCircle"
            ],
            [
              "text",
              "ComponentText"
            ],
            [
              "event",
              "componentEvent"
            ]
          ]
        },
        {
          "type": "input_dummy"
        },
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        }
      ],
      "inputsInline": false,
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Add a component to an object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var component = block.getFieldValue('component');
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'addComponentToObject(\\\\"' + component + '\\\\", ' + object + ');';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');