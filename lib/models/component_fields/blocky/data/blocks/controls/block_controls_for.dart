import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

final ToolboxBlock blockControlsFor = ToolboxBlock(type: "controls_for")
  ..addField("VAR", "controls_for")
  ..addValue("FROM", ToolboxBlockShadow(
      type: "math_number",
      field: ToolboxBlockField(name: "NUM", type: "1"))
  )
  ..addValue("TO", ToolboxBlockShadow(
      type: "math_number",
      field: ToolboxBlockField(name: "NUM", type: "10"))
  )
  ..addValue("BY", ToolboxBlockShadow(
    type: "math_number",
    field: ToolboxBlockField(name: "NUM", type: "1"))
  );