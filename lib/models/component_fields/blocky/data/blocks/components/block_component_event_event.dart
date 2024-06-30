import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Component Event Event
final blockEventEvent = ToolboxBlock(type: "event_event");

/// Custom : Component Event Event block data.
final blockEventEventJson = CustomBlock.fromJson(
    {
      "type": "event_event",
      "message0": "Set event of object %1 %2",
      "args0": [
        {
          "type": "input_value",
          "name": "object",
          "check": "Number"
        },
        {
          "type": "input_statement",
          "name": "event"
        }
      ],
      "previousStatement": null,
      "nextStatement": null,
      "colour": 230,
      "tooltip": "Set event content of an object",
      "helpUrl": ""
    }
).setFunctionLua('''
  var object = generator.valueToCode(block, 'object', lua.Order.ATOMIC);
  var event = generator.statementToCode(block, 'event');
  var result = 'object = ' + object + ';';
  result += 'event = \\\\"' + event + '\\\\";';
  result += 'changeEventEvent(object,event);';
  return result;
''').setFunctionDart('''return 'print(\\\\"not implemented\\\\")';''')
    .setFunctionJs('''
  return 'console.log(\\\\"not implemented\\\\")';
''').setFunctionPhp('''
  return 'print(\\\\"not implemented\\\\")';
''').setFunctionPython('''
  return 'print(\\\\"not implemented\\\\")';
''');