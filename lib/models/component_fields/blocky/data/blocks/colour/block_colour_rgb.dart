import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../block_data/toolbox_block_field.dart';
import '../../../toolbox_block.dart';

final blockColourRgb = ToolboxBlock(type: "colour_rgb")
    .addValue("RED", ToolboxBlockShadow(type: "math_number", field: ToolboxBlockField(name: "NUM", type: "100")))
    .addValue("GREEN", ToolboxBlockShadow(type: "math_number", field: ToolboxBlockField(name: "NUM", type: "50")))
    .addValue("BLUE", ToolboxBlockShadow(type: "math_number", field: ToolboxBlockField(name: "NUM", type: "0")));
