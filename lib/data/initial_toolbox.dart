import 'package:plock_mobile/models/component_fields/blocky/data/blocks/colour/block_colour_rgb.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/bloc_component_event_trigger.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_event_event.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_rect_color.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_rect_get_height.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_rect_get_width.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_rect_height.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_rect_width.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_variable_get_value.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_variable_value.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/controls/block_controls_for.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/controls/block_controls_repeat_ext.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_create_with.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_get_index.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_get_sublist.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_index_of.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_repeat.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_set_index.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_sort.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/lists/block_lists_split.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/logic/block_wait.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_delta_time.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_arithmetic.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_constrain.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_modulo.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_number_property.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_random_int.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_round.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_single.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/math/block_math_trig.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/bloc_object_add_component.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/bloc_object_destroy.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/bloc_object_spawn.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_color.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_get_colour.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_get_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_circle_radius.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_color.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_get_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/components/block_component_text_text.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_add_event.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_get_pos_x.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_get_pos_y.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_last.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_move.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_name.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_pos_x.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_pos_y.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/objects/block_object_this.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/logic/block_get_screen_height.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/logic/block_get_screen_width.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_append.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_change_case.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_charat.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_get_substring.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_index_of.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_is_empty.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_length.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_print.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_prompt_ext.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_to_number.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_to_string.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/blocks/text/block_text_trim.dart';
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
        ToolboxBlock(type: "controls_if"),
        ToolboxBlock(type: "logic_compare").addField("OP", "EQ"),
        ToolboxBlock(type: "logic_operation").addField("OP", "AND"),
        ToolboxBlock(type: "logic_negate"),
        ToolboxBlock(type: "logic_boolean").addField("BOOL", "TRUE"),
        ToolboxBlock(type: "logic_null"),
        //ToolboxBlock(type: "logic_ternary"),
        blockWait,
        blockGetScreenWidth,
        blockGetScreenHeight,
      ],
  ),
  ToolboxCategory(
      name: "loops",
      blocks: [
        blockControlsRepeatExt,
        ToolboxBlock(type: "controls_whileUntil").addField("MODE", "WHILE"),
        blockControlsFor,
        ToolboxBlock(type: "controls_forEach"),
        ToolboxBlock(type: "controls_flow_statements").addField("FLOW", "BREAK"),
      ],
  ),
  ToolboxCategory(
      name: "math",
      blocks: [
        ToolboxBlock(type: "math_number").addField("NUM", "0"),
        blockDeltaTime,
        blockMathArithmetic,
        blockMathRound,
        blockMathSingle,
        blockMathTrig,
        ToolboxBlock(type: "math_constant").addField("CONSTANT", "PI"),
        blockMathNumberProperty,
        ToolboxBlock(type: "math_on_list").addMutation(op: "SUM").addField("OP", "SUM"),
        blockMathModulo,
        blockMathConstrain,
        blockMathRandomInt,
        ToolboxBlock(type: "math_random_float"),
      ],
  ),
  ToolboxCategory(
      name: "text",
      blocks: [
        blockTextCharAt,
        ToolboxBlock(type: "text").addField("TEXT", "text"),
        blockTextToString,
        blockTextAppend,
        blockTextLength,
        blockTextIsEmpty,
        blockTextIndexOf,
        ToolboxBlock(type: "text_join").addMutation(items: "2"),
        blockTextGetSubstring,
        blockTextChangeCase,
        blockTextTrim,
        blockTextPrint,
        blockTextPromptExt,
        blockTextToNumber,
      ]
  ),
  ToolboxCategory(
      name: "lists",
      blocks: [
        blockListsIndexOf,
        blockListsCreateWith,
        blockListRepeat,
        ToolboxBlock(type: "lists_length"),
        ToolboxBlock(type: "lists_isEmpty"),
        ToolboxBlock(type: "lists_create_with").addMutation(items: "3"),
        blockListGetIndex,
        blockListsSetIndex,
        blockListsGetSublist,
        blockListsSplit,
        blockListsSort,
      ]
  ),
  ToolboxCategory(
      name: "colour",
      blocks: [
        ToolboxBlock(type: "colour_picker").addField("COLOUR", "#ff0000"),
        //ToolboxBlock(type: "colour_random"),
        blockColourRgb,
        //blockColourBlend,
      ]
  ),
  ToolboxCategory(
      name: "components",
      blocks: [
        // Rect
        blockRectWidth,
        blockRectHeight,
        blockRectColour,
        blockGetRectWidth,
        blockGetRectHeight,
        // Text
        blockTextText,
        blockTextColour,
        blockGetTextText,
        // Circle
        blockCircleRadius,
        blockCircleColour,
        blockGetCircleRadius,
        blockGetCircleColour,
        // Event
        blockEventEvent,
        blockEventTrigger,
        // Variable
        blockGetVariableValue,
        blockVariableValue,
      ]
  ),
  ToolboxCategory(
      name: "objects",
      blocks: [
        blockObjectPosX,
        blockObjectPosY,
        blockGetObjectPosX,
        blockGetObjectPosY,
        blockObjectMove,
        blockObjectThis,
        blockObjectName,
        blockObjectLast,
        blockObjectSpawn,
        blockObjectDestroy,
        blockObjectAddComponent,
        blockObjectAddEvent,
      ]
  ),
  ToolboxCategory(
      name: "variables",
      custom: "VARIABLE",
  ),
]);