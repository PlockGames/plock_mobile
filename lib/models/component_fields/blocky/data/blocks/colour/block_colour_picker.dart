import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../custom_block.dart';
import '../../../toolbox_block.dart';

/// Custom : Colour RGB block.
final blockColourPicker = ToolboxBlock(type: "colour_picker");

/// Custom : Colour RGB block data.
final blockColourPickerJson = CustomBlock.fromJson(
    {
      'type': "colour_picker",
      'message0': '%1',
      'args0': [
        {
          'type': 'field_colour',
          'name': 'COLOUR',
          'colour': '#ff0000',
        },
      ],
      'output': 'Colour',
      'helpUrl': '',
      'style': 'colour_blocks',
      "colour": 230,
      'tooltip': 'Choose a color',
      'extensions': ['parent_tooltip_when_inline'],
    }
).setFunctionLua('''
    const code = generator.quote_(block.getFieldValue('COLOUR'));
    return [code, lua.Order.ATOMIC];
''').setFunctionDart('''
  return '';
''').setFunctionJs('''
  return '';
''').setFunctionPhp('''
  return '';
''').setFunctionPython('''
  return '';
''');
