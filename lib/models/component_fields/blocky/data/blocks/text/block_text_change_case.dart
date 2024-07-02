import '../../../toolbox_block.dart';

/// Blockly : Text Get Substring block.
final blockTextChangeCase = ToolboxBlock(type: "text_changeCase")
    .addField("CASE", "UPPERCASE")
    .addValue(
      "TEXT",
      ToolboxBlock(type: "text")
          .addField("TEXT", "abc")
    );