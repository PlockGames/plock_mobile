import '../../../toolbox_block.dart';

final blockListsGetSublist = ToolboxBlock(type: "lists_getSublist",)
    .addMutation(at1: true, at2: true)
    .addField("WHERE1", "FROM_START")
    .addField("WHERE2", "FROM_START")
    .addValue("LIST", ToolboxBlock(type: "variables_get").addField("VAR", "list"));