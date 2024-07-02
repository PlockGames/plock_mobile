import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

/// Blockly : Math Single block.
final ToolboxBlock blockMathSingle = ToolboxBlock(type: "math_single")
  ..addField("OP", "ROOT")
  ..addValue("NUM", ToolboxBlockShadow(
    type: "math_number",
    field: ToolboxBlockField(name: "NUM", type: "9"))
  );