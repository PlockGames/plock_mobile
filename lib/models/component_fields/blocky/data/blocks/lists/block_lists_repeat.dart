import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../toolbox_block.dart';

/// Blockly : Lists Repeat block.
final blockListRepeat = ToolboxBlock(type: "lists_repeat")
    .addValue("NUM", ToolboxBlockShadow(
        type: "math_number",
        field: ToolboxBlockField(
            name: "NUM",
            type: "10"
        )
    )
);