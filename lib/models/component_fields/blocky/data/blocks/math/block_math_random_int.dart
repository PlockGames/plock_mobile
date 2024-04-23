import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';

final ToolboxBlock blockMathRandomInt = ToolboxBlock(type: "math_random_int")
    .addValue(
      "FROM",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "0")
      ),
    )
    .addValue(
      "TO",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "100")
      ),
    );