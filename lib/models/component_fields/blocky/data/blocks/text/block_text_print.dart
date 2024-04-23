import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

final blockTextPrint = ToolboxBlock(type: "text_print")
    .addValue("TEXT",
      ToolboxBlockShadow(
          type: "text",
          field: ToolboxBlockField(
              name: "TEXT",
              type: "abc"
          )
      )
    );