import '../../../toolbox_block.dart';

final blockTextAppend = ToolboxBlock(type: "text_append")
    .addField("VAR", "item")
    .addValue(
      "TEXT",
      ToolboxBlock(type: "text").addField("TEXT", ""),
    );