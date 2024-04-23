import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

import '../../../toolbox_block.dart';

final blockColourBlend = ToolboxBlock(type: "colour_blend")
    .addValue("COLOUR1", ToolboxBlockShadow(type: "colour_picker", field: ToolboxBlockField(name: "COLOUR", type: "#ff0000")))
    .addValue("COLOUR2", ToolboxBlockShadow(type: "colour_picker", field: ToolboxBlockField(name: "COLOUR", type: "#3333ff")))
    .addValue("RATIO", ToolboxBlockShadow(type: "math_number", field: ToolboxBlockField(name: "NUM", type: "0.5")));