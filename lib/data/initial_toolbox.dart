import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_create_with.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_get_index.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_get_sublist.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_index_of.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_is_empty.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_length.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_repeat.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_set_index.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_sort.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/lists/lists_split.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/logic/controls_if.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/logic/logic_boolean.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/logic/logic_compare.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/logic/logic_negate.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/logic/logic_null.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/logic/logic_operation.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/loops/control_flow_statement.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/loops/control_for_each.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/loops/control_repeat_ext.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/loops/controls_for.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/loops/controls_repeat.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/loops/controls_while_until.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_arithmetic.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_atan2.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_constant.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_constrain.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_modulo.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_number.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_number_property.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_on_list.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_random_float.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_random_int.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_round.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_single.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/math/math_trig.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_append.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_change_case.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_char_at.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_count.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_get_substring.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_index_of.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_is_empty.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_join.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_length.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_print.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_prompt_ext.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_replace.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_reverse.dart';
import 'package:plock_mobile/models/component_fields/blocky/blocks/text/text_trim.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/colour/colour_blend.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/colour/colour_picker.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/colour/colour_random.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/colour/colour_rgb.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/component_get.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/component_set.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/object.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/object_add_component.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/object_destroy.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/object_get.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/object_set.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/objects/object_spawn.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/system/delta_time.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/system/screen_get.dart';
import 'package:plock_mobile/models/component_fields/blocky/custom_blocks/system/wait.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_category.dart';


/// The initial toolbox of the blockly.
///
/// A list of all the blocks that can be used in the blockly.
final initialToolbox = Toolbox(categories: [
  ToolboxCategory(
      name: "logic",
      blocks: [
        ToolboxBlock(data: block_controls_if),
        ToolboxBlock(data: block_logic_compare),
        ToolboxBlock(data: block_logic_operation),
        ToolboxBlock(data: block_logic_negate),
        ToolboxBlock(data: block_logic_boolean),
        ToolboxBlock(data: block_logic_null),
      ],
  ),
  ToolboxCategory(
      name: "loops",
      blocks: [
        ToolboxBlock(data: block_control_repeat_ext),
        ToolboxBlock(data: block_control_for_each),
        ToolboxBlock(data: block_controls_for),
        ToolboxBlock(data: block_controls_repeat),
        ToolboxBlock(data: block_controls_while_until),
        ToolboxBlock(data: block_control_flow_statement)
      ],
  ),
  ToolboxCategory(
      name: "math",
      blocks: [
        ToolboxBlock(data: block_math_number),
        ToolboxBlock(data: block_math_arithmetic),
        ToolboxBlock(data: block_math_atan2),
        ToolboxBlock(data: block_math_modulo),
        ToolboxBlock(data: block_math_constant),
        ToolboxBlock(data: block_math_constrain),
        ToolboxBlock(data: block_math_number_property),
        ToolboxBlock(data: block_math_on_list),
        ToolboxBlock(data: block_math_random_float),
        ToolboxBlock(data: block_math_random_int),
        ToolboxBlock(data: block_math_round),
        ToolboxBlock(data: block_math_single),
        ToolboxBlock(data: block_math_trig)
      ],
  ),
  ToolboxCategory(
      name: "text",
      blocks: [
        ToolboxBlock(data: block_text),
        ToolboxBlock(data: block_text_append),
        ToolboxBlock(data: block_text_change_case),
        ToolboxBlock(data: block_text_char_at),
        ToolboxBlock(data: block_text_count),
        ToolboxBlock(data: block_text_get_substring),
        ToolboxBlock(data: block_text_index_of),
        ToolboxBlock(data: block_text_is_empty),
        ToolboxBlock(data: block_text_join),
        ToolboxBlock(data: block_text_length),
        //ToolboxBlock(data: block_text_print),
        //ToolboxBlock(data: block_text_prompt_ext),
        ToolboxBlock(data: block_text_replace),
        ToolboxBlock(data: block_text_reverse),
        ToolboxBlock(data: block_text_trim)
      ]
  ),
  ToolboxCategory(
      name: "lists",
      blocks: [
        ToolboxBlock(data: block_lists_create_with),
        ToolboxBlock(data: block_lists_get_index),
        ToolboxBlock(data: block_lists_get_sublist),
        ToolboxBlock(data: block_lists_index_of),
        ToolboxBlock(data: block_lists_is_empty),
        ToolboxBlock(data: block_lists_length),
        ToolboxBlock(data: block_lists_repeat),
        ToolboxBlock(data: block_text_reverse),
        ToolboxBlock(data: block_lists_set_index),
        ToolboxBlock(data: block_lists_sort),
        ToolboxBlock(data: block_lists_split)

      ]
  ),
  ToolboxCategory(
      name: "colour",
      blocks: [
        ToolboxBlock(data: block_colour_blend),
        ToolboxBlock(data: block_colour_picker),
        ToolboxBlock(data: block_colour_random),
        ToolboxBlock(data: block_colour_rgb)
      ]
  ),
  ToolboxCategory(
      name: "system",
      blocks: [
        ToolboxBlock(data: block_delta_time),
        ToolboxBlock(data: block_screen_get),
        ToolboxBlock(data: block_wait)
      ]
  ),
  ToolboxCategory(
      name: "objects",
      blocks: [
        ToolboxBlock(data: block_object),
        ToolboxBlock(data: block_component_get),
        ToolboxBlock(data: block_component_set),
        ToolboxBlock(data: block_object_add_component),
        ToolboxBlock(data: block_object_destroy),
        ToolboxBlock(data: block_object_get),
        ToolboxBlock(data: block_object_set),
        ToolboxBlock(data: block_object_spawn)
      ]
  ),
  ToolboxCategory(
      name: "variables",
      custom: "VARIABLE",
  ),
]);