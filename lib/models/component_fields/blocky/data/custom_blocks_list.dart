import 'package:plock_mobile/models/component_fields/blocky/custom_blocks_manager.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_get_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_to_string.dart';

import 'blocks/components/block_component_rect_get_height.dart';
import 'blocks/components/block_component_rect_get_width.dart';
import 'blocks/components/block_component_rect_height.dart';
import 'blocks/components/block_component_rect_width.dart';
import 'blocks/components/block_object_pos_x.dart';
import 'blocks/components/block_object_pos_y.dart';
import 'blocks/text/block_text_to_number.dart';

CustomBlocksManager customBlocksManager = CustomBlocksManager()
    .addBlock(blockRectWidthJson)
    .addBlock(blockRectHeightJson)
    .addBlock(blockGetRectWidthJson)
    .addBlock(blockGetRectHeightJson)
    .addBlock(blockTextTextJson)
    .addBlock(blockTextToStringJson)
    .addBlock(blockObjectPosXJson)
    .addBlock(blockObjectPosYJson)
    .addBlock(blockTextToNumberJson)
    .addBlock(blockGetTextTextJson);