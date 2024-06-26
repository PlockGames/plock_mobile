import 'package:plock_mobile/models/component_fields/blocky/custom_blocks_manager.dart';

import 'blocks/components/block_component_get_rect_width.dart';
import 'blocks/components/block_component_rect_height.dart';
import 'blocks/components/block_component_rect_width.dart';

CustomBlocksManager customBlocksManager = CustomBlocksManager()
    .addBlock(blockRectWidthJson)
    .addBlock(blockRectHeightJson)
    .addBlock(blockGetRectWidthJson);