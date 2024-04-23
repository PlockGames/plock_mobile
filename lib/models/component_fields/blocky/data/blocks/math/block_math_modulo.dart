import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';

final ToolboxBlock blockMathModulo = ToolboxBlock(type: "math_modulo")
    .addMutation(divisorInput: false)
    .addValue(
      "DIVIDEND",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "64")
      ),
    )
    .addValue(
      "DIVISOR",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "10")
      ),
    );