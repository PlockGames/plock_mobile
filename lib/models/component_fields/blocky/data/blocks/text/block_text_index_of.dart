import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

final blockTextIndexOf = ToolboxBlock(type: "text_indexOf")
    .addField("END", "FIRST")
    .addValue("VALUE", ToolboxBlock(type: "variables_get").addField("VAR", "text"))
    .addValue(
      "FIND",
      ToolboxBlockShadow(
          type: "text",
          field: ToolboxBlockField(
              name: "FIND",
              type: "abc"
          )
      )
    );