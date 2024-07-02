import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';

/// Blockly : Controls Repeat Ext block.
final ToolboxBlock blockControlsRepeatExt = ToolboxBlock(
    type: "controls_repeat_ext")
      ..addValue(
          "TIMES",
          ToolboxBlockShadow(
              type: "math_number",
              field: ToolboxBlockField(name: "NUM", type: "1")
          )
);