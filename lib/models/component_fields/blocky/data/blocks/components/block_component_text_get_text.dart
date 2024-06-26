import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

final blockGetTextText = ToolboxBlock(type: "text_get_text");

final blockGetTextTextJson = CustomBlock.fromJson(
    {
      "type": "text_get_text",
      "message0": "Get text of object  %1",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "String"
        }
      ],
      "output": "String",
      "colour": 230,
      "tooltip": "Get the text of the text component",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  object = object.slice(1, -1);
  var result = 'game[\\\\"' + object + '\\\\"][\\\\"ComponentText\\\\"][\\\\"text\\\\"]';
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