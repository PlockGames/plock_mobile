import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Colour RGB block.
final blockColourRgb = ToolboxBlock(type: "colour_rgb");

/// Custom : Colour RGB block data.
final blockColourRgbJson = CustomBlock.fromJson(
    {
      "type": "colour_rgb",
      "message0":
      '%{BKY_COLOUR_RGB_TITLE} %{BKY_COLOUR_RGB_RED} %1 %{BKY_COLOUR_RGB_GREEN} %2 %{BKY_COLOUR_RGB_BLUE} %3',
      "args0": [
        {
          "type": 'input_value',
          "name": 'RED',
          "check": 'Number',
          "align": 'RIGHT',
        },
        {
          "type": 'input_value',
          "name": 'GREEN',
          "check": 'Number',
          "align": 'RIGHT',
        },
        {
          "type": 'input_value',
          "name": 'BLUE',
          "check": 'Number',
          "align": 'RIGHT',
        },
      ],
      "output": 'Colour',
      "colour": 230,
      "helpUrl": '%{BKY_COLOUR_RGB_HELPURL}',
      "style": 'colour_blocks',
      "tooltip": '%{BKY_COLOUR_RGB_TOOLTIP}',
    }
).setFunctionLua('''
  const red = generator.valueToCode(block, 'RED', lua.Order.NONE) || 0;
  const green = generator.valueToCode(block, 'GREEN', lua.Order.NONE) || 0;
  const blue = generator.valueToCode(block, 'BLUE', lua.Order.NONE) || 0;
  const code = `rgbToColor(\${red}, \${green}, \${blue})`;
  return [code, lua.Order.HIGH];
''').setFunctionDart('''
  return '';
''').setFunctionJs('''
  return '';
''').setFunctionPhp('''
  return '';
''').setFunctionPython('''
  return '';
''');
