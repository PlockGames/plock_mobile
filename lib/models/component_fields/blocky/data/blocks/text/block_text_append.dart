import '../../../toolbox_block.dart';

/// Blockly : Text Get Substring block.
final blockTextAppend = ToolboxBlock(type: "text_append")
    .addField("VAR", "item")
    .addValue(
      "TEXT",
      ToolboxBlock(type: "text").addField("TEXT", ""),
    );