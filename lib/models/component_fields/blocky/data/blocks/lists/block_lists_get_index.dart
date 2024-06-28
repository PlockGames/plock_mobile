import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

/// Blockly : Lists Get Index block.
final blockListGetIndex = ToolboxBlock(type: "lists_getIndex")
    .addMutation(statement: false, at: true)
    .addField("MODE", "GET")
    .addField("WHERE", "FROM_START")
    .addValue("VALUE", ToolboxBlock(type: "variables_get").addField("VAR", "list")
);