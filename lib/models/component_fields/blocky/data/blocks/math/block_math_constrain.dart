import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';

final ToolboxBlock blockMathConstrain = ToolboxBlock(type: "math_constrain")
    .addValue(
      "VALUE",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "50")
      ),
    )
    .addValue(
      "LOW",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "1")
      ),
    )
    .addValue(
      "HIGH",
      ToolboxBlockShadow(
          type: "math_number",
          field: ToolboxBlockField(
              name: "NUM",
              type: "100")
      ),
    );