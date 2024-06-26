import 'package:plock_mobile/models/component_fields/blocky/toolbox.dart';
import 'package:plock_mobile/models/component_fields/blocky/toolbox_category.dart';

import '../toolbox_block.dart';
import 'blocks/colour/block_colour_blend.dart';
import 'blocks/colour/block_colour_rgb.dart';
import 'blocks/components/block_component_get_rect_width.dart';
import 'blocks/components/block_component_rect_height.dart';
import 'blocks/components/block_component_rect_width.dart';
import 'blocks/controls/block_controls_for.dart';
import 'blocks/controls/block_controls_repeat_ext.dart';
import 'blocks/lists/block_lists_create_with.dart';
import 'blocks/lists/block_lists_get_index.dart';
import 'blocks/lists/block_lists_get_sublist.dart';
import 'blocks/lists/block_lists_index_of.dart';
import 'blocks/lists/block_lists_repeat.dart';
import 'blocks/lists/block_lists_set_index.dart';
import 'blocks/lists/block_lists_sort.dart';
import 'blocks/lists/block_lists_split.dart';
import 'blocks/math/block_math_arithmetic.dart';
import 'blocks/math/block_math_constrain.dart';
import 'blocks/math/block_math_modulo.dart';
import 'blocks/math/block_math_number_property.dart';
import 'blocks/math/block_math_random_int.dart';
import 'blocks/math/block_math_round.dart';
import 'blocks/math/block_math_single.dart';
import 'blocks/math/block_math_trig.dart';
import 'blocks/text/block_text_append.dart';
import 'blocks/text/block_text_change_case.dart';
import 'blocks/text/block_text_charat.dart';
import 'blocks/text/block_text_get_substring.dart';
import 'blocks/text/block_text_index_of.dart';
import 'blocks/text/block_text_is_empty.dart';
import 'blocks/text/block_text_length.dart';
import 'blocks/text/block_text_print.dart';
import 'blocks/text/block_text_prompt_ext.dart';
import 'blocks/text/block_text_trim.dart';

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
        blockMathRound,
        ToolboxBlock(type: "math_number").addField("NUM", "0"),
        blockMathSingle,
        blockMathTrig,
        ToolboxBlock(type: "math_constant").addField("CONSTANT", "PI"),
        blockMathNumberProperty,
        blockMathArithmetic,
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
        //ToolboxBlock(type: "colour_picker").addField("COLOUR", "#ff0000"), // BROKEN ! TO FIX...
        ToolboxBlock(type: "colour_random"),
        blockColourRgb,
        blockColourBlend,
      ]
  ),
  ToolboxCategory(
      name: "components",
      blocks: [
        blockRectWidth,
        blockRectHeight,
        blockGetRectWidth,
      ]
  ),
  ToolboxCategory(
      name: "variables",
      custom: "VARIABLE",
  ),
]);