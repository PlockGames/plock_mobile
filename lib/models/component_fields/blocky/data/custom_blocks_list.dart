import 'package:plock_mobile/models/component_fields/blocky/custom_blocks_manager.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_get_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_get_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_object_get_pos_x.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_object_get_pos_y.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_to_string.dart';

import 'blocks/components/block_component_rect_get_height.dart';
import 'blocks/components/block_component_rect_get_width.dart';
import 'blocks/components/block_component_rect_height.dart';
import 'blocks/components/block_component_rect_width.dart';
import 'blocks/components/block_object_pos_x.dart';
import 'blocks/components/block_object_pos_y.dart';
import 'blocks/components/block_wait.dart';
import 'blocks/text/block_text_to_number.dart';

CustomBlocksManager customBlocksManager = CustomBlocksManager()
    .addBlock(blockTextToNumberJson)
    .addBlock(blockTextToStringJson)
    .addBlock(blockWaitJson)
    .addBlock(blockRectWidthJson)
    .addBlock(blockRectHeightJson)
    .addBlock(blockGetRectWidthJson)
    .addBlock(blockGetRectHeightJson)
    .addBlock(blockTextTextJson)
    .addBlock(blockGetTextTextJson)
    .addBlock(blockObjectPosXJson)
    .addBlock(blockObjectPosYJson)
    .addBlock(blockGetObjectPosXJson)
    .addBlock(blockGetObjectPosYJson)
    .addBlock(blockCircleRadiusJson)
    .addBlock(blockGetCircleRadiusJson);
