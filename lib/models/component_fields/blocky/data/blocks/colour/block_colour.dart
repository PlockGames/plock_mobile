import 'package:plock_mobile/models/component_fields/blocky/custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Object this block.
final blockColour = ToolboxBlock(type: "colour_hsv_sliders");

/// Custom : Object this block data.
final blockColourJson = CustomBlock.fromJson(
      {
            "type": 'colour_hsv_sliders',
            "message0": 'hsv %1',
            "args0": [
                  {
                        "type": 'field_colour_hsv_sliders',
                        "name": 'COLOUR',
                        "colour": '#ff0000',
                  },
            ],
            "output": 'Colour',
            "style": 'colour_blocks',
            "colour": 230,
            "tooltip": "Return a colour value",
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