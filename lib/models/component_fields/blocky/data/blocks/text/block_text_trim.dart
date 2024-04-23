import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

final blockTextTrim = ToolboxBlock(type: "text_trim")
    .addField("MODE", "BOTH")
    .addValue("TEXT",
      ToolboxBlockShadow(
          type: "text",
          field: ToolboxBlockField(
              name: "TEXT",
              type: "abc"
          )
      )
);