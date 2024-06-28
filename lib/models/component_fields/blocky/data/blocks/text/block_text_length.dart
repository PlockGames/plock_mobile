import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../toolbox_block.dart';

/// Blockly : Text Length block.
final blockTextLength = ToolboxBlock(type: "text_length")
    .addValue("VALUE",
      ToolboxBlockShadow(
          type: "text",
          field: ToolboxBlockField(
              name: "TEXT",
              type: "abc"
          )
      )
);