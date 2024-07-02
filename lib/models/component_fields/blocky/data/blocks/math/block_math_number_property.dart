import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';

/// Blockly : Math Random Int block.
final ToolboxBlock blockMathNumberProperty = ToolboxBlock(type: "math_number_property")
    .addMutation(divisorInput: false)
    .addField("PROPERTY", "EVEN")
    .addValue(
      "NUMBER_TO_CHECK",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "0")
      ),
);