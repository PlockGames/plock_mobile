import '../../../block_data/toolbox_block_field.dart';
import '../../../block_data/toolbox_block_shadow.dart';
import '../../../toolbox_block.dart';

/// Blockly : Text Prompt Ext block.
final blockTextPromptExt = ToolboxBlock(type: "text_prompt_ext")
    .addMutation(type: "TEXT")
    .addField("TYPE", "TEXT")
    .addValue("TEXT", ToolboxBlockShadow(
        type: "text",
        field: ToolboxBlockField(
            name: "TEXT",
            type: "abc"
        )
    )
);