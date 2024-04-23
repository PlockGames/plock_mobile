import '../../../toolbox_block.dart';

final blockListsSetIndex = ToolboxBlock(type: "lists_setIndex")
    .addMutation(at: true)
    .addField("MODE", "SET")
    .addField("WHERE", "FROM_START")
    .addValue("LIST", ToolboxBlock(type: "variables_get").addField("VAR", "list"));