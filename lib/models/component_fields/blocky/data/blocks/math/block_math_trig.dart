import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

/// Blockly : Math Trig block.
final ToolboxBlock blockMathTrig = ToolboxBlock(type: "math_trig")
    .addField("OP", "SIN")
    .addValue(
      "NUM",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "0")
      ),
);