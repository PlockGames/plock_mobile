import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Text Get Text block.
final blockGetVariableValue = ToolboxBlock(type: "variable_get_value");

/// Custom : Text Get Text block data.
final blockGetVariableValueJson = CustomBlock.fromJson(
    {
      "type": "variable_get_value",
      "message0": "Get variable %1 value of object  %2",
      "args0": [
        {
          "type": "input_value",
          "name": "value",
          "check": "String"
        },
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        }
      ],
      "output": "String",
      "colour": 230,
      "tooltip": "Get the value of the variable component",
      "helpUrl": ""
    }
).setFunctionLua('''
  var value = generator.valueToCode(block, 'value', lua.Order.ATOMIC);
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var result = 'getVariableValue(' + value + ', ' + object + ')';
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