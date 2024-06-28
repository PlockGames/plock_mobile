import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../toolbox_block.dart';

/// Blockly : Text is Empty block.
final blockTextIsEmpty = ToolboxBlock(type: "text_isEmpty")
    .addValue(
      "VALUE",
      ToolboxBlockShadow(
          type: "text",
          field: ToolboxBlockField(
              name: "TEXT",
              type: "")
      ),
);