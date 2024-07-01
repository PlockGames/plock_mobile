import 'package:plock_mobile/models/component_fields/blocky/custom_blocks_manager.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/colour/block_colour.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/bloc_component_event_trigger.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_event_event.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/bloc_object_add_component.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/bloc_object_spawn.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_color.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_get_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_color.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_get_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_add_event.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_get_pos_y.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_name.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_this.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/logic/block_get_screen_height.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/logic/block_get_screen_width.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_to_string.dart';

import '../models/component_fields/blocky/data/blocks/colour/block_colour_picker.dart';
import '../models/component_fields/blocky/data/blocks/colour/block_colour_rgb.dart';
import '../models/component_fields/blocky/data/blocks/objects/bloc_object_destroy.dart';
import '../models/component_fields/blocky/data/blocks/components/block_component_circle_get_colour.dart';
import '../models/component_fields/blocky/data/blocks/components/block_component_rect_color.dart';
import '../models/component_fields/blocky/data/blocks/components/block_component_rect_get_height.dart';
import '../models/component_fields/blocky/data/blocks/components/block_component_rect_get_width.dart';
import '../models/component_fields/blocky/data/blocks/components/block_component_rect_height.dart';
import '../models/component_fields/blocky/data/blocks/components/block_component_rect_width.dart';
import '../models/component_fields/blocky/data/blocks/objects/block_object_get_pos_x.dart';
import '../models/component_fields/blocky/data/blocks/objects/block_object_last.dart';
import '../models/component_fields/blocky/data/blocks/objects/block_object_move.dart';
import '../models/component_fields/blocky/data/blocks/objects/block_object_pos_x.dart';
import '../models/component_fields/blocky/data/blocks/objects/block_object_pos_y.dart';
import '../models/component_fields/blocky/data/blocks/logic/block_wait.dart';
import '../models/component_fields/blocky/data/blocks/text/block_text_to_number.dart';

/// A list of all the custom blocks for blockly.
CustomBlocksManager customBlocksManager = CustomBlocksManager()
    // system
    .addBlock(blockTextToNumberJson)
    .addBlock(blockTextToStringJson)
    .addBlock(blockWaitJson)
    .addBlock(blockGetScreenWidthJson)
    .addBlock(blockGetScreenHeightJson)
    .addBlock(blockColourRgbJson)
    .addBlock(blockColourPickerJson)
    // component rect
    .addBlock(blockRectWidthJson)
    .addBlock(blockRectHeightJson)
    .addBlock(blockRectColourJson)
    .addBlock(blockGetRectWidthJson)
    .addBlock(blockGetRectHeightJson)
    // component text
    .addBlock(blockTextTextJson)
    .addBlock(blockTextColourJson)
    .addBlock(blockGetTextTextJson)
    // component circle
    .addBlock(blockCircleRadiusJson)
    .addBlock(blockCircleColourJson)
    .addBlock(blockGetCircleRadiusJson)
    .addBlock(blockGetCircleColourJson)
    // component event
    .addBlock(blockEventEventJson)
    .addBlock(blockEventTriggerJson)
    // object
    .addBlock(blockObjectPosXJson)
    .addBlock(blockObjectPosYJson)
    .addBlock(blockGetObjectPosXJson)
    .addBlock(blockGetObjectPosYJson)
    .addBlock(blockObjectMoveJson)
    .addBlock(blockObjectThisJson)
    .addBlock(blockObjectNameJson)
    .addBlock(blockObjectLastJson)
    .addBlock(blockObjectSpawnJson)
    .addBlock(blockObjectDestroyJson)
    .addBlock(blockObjectAddComponentJson)
    .addBlock(blockObjectAddEventJson);
