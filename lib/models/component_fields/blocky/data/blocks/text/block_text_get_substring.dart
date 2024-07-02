import '../../../toolbox_block.dart';

/// Blockly : Text Get Substring block.
final blockTextGetSubstring = ToolboxBlock(type: "text_getSubstring")
    .addMutation(at1: true)
    .addMutation(at2: true)
    .addField("WHERE1", "FROM_START")
    .addField("WHERE2", "FROM_START")
    .addValue(
      "STRING",
      ToolboxBlock(type: "variables_get").addField("VAR", "text"),
    );