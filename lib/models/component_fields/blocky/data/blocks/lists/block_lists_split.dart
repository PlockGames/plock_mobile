import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../toolbox_block.dart';

final blockListsSplit = ToolboxBlock(type: "lists_split",)
    .addMutation(mode: "SPLIT")
    .addField("MODE", "SPLIT")
    .addValue(
      "DELIM",
      ToolboxBlockShadow(
          type: "text",
          field: ToolboxBlockField(
              name: "TEXT",
              type: ","
          )
      )
);