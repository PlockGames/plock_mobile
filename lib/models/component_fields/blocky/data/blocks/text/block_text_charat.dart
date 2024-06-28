import '../../../toolbox_block.dart';

/// Blockly : Text Get Substring block.
final ToolboxBlock blockTextCharAt = ToolboxBlock(type: "text_charAt")
    .addMutation( at: true)
    .addField("WHERE", "FROM_START")
    .addValue(
      "VALUE",
      ToolboxBlock(type: "variables_get").addField("VAR", "text"),
);