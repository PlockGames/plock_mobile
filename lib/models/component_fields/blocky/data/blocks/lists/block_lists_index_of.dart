import '../../../toolbox_block.dart';

final blockListsIndexOf = ToolboxBlock(type: "lists_indexOf",)
    .addField("END", "FIRST")
    .addValue(
      "VALUE",
      ToolboxBlock(type: "variables_get").addField("VAR", "list")
);