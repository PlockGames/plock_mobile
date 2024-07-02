import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

/// The text_trim block.
final ToolboxBlock blockMathRound = ToolboxBlock(type: "math_round")
  ..addField("NUM", "1.9")
  ..addValue("NUM", ToolboxBlockShadow(
    type: "math_number",
    field: ToolboxBlockField(name: "NUM", type: "3.1"))
  );