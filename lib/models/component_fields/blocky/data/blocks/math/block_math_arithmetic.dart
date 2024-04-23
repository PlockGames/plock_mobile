import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

final ToolboxBlock blockMathArithmetic = ToolboxBlock(type: "math_arithmetic")
    .addField("OP", "ADD")
    .addValue(
      "A",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "0")
      ),
    )
    .addValue(
      "B",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "0")
      ),
    );