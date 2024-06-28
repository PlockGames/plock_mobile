import 'package:plock_mobile/models/component_fields/blocky/custom_blocks_manager.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/colour/block_colour.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_get_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_get_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_object_get_pos_x.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_object_get_pos_y.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_object_move.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_object_name.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_object_this.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/logic/block_get_screen_height.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/logic/block_get_screen_width.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_to_string.dart';

import 'blocks/components/block_component_rect_get_height.dart';
import 'blocks/components/block_component_rect_get_width.dart';
import 'blocks/components/block_component_rect_height.dart';
import 'blocks/components/block_component_rect_width.dart';
import 'blocks/components/block_object_pos_x.dart';
import 'blocks/components/block_object_pos_y.dart';
import 'blocks/logic/block_wait.dart';
import 'blocks/text/block_text_to_number.dart';

/// A list of all the custom blocks for blockly.
CustomBlocksManager customBlocksManager = CustomBlocksManager()
    // system
    .addBlock(blockTextToNumberJson)
    .addBlock(blockTextToStringJson)
    .addBlock(blockWaitJson)
    .addBlock(blockGetScreenWidthJson)
    .addBlock(blockGetScreenHeightJson)
    .addBlock(blockColourJson)
    // component rect
    .addBlock(blockRectWidthJson)
    .addBlock(blockRectHeightJson)
    .addBlock(blockGetRectWidthJson)
    .addBlock(blockGetRectHeightJson)
    // component text
    .addBlock(blockTextTextJson)
    .addBlock(blockGetTextTextJson)
    // component circle
    .addBlock(blockCircleRadiusJson)
    .addBlock(blockGetCircleRadiusJson)
    // object
    .addBlock(blockObjectPosXJson)
    .addBlock(blockObjectPosYJson)
    .addBlock(blockGetObjectPosXJson)
    .addBlock(blockGetObjectPosYJson)
    .addBlock(blockObjectMoveJson)
    .addBlock(blockObjectThisJson)
    .addBlock(blockObjectNameJson);
