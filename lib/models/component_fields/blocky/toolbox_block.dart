import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';

import 'block_data/toolbox_block_data.dart';
import 'block_data/toolbox_block_mutation.dart';
import 'block_data/toolbox_block_shadow.dart';
import 'block_data/toolbox_block_value.dart';

class ToolboxBlock extends ToolboxBlockData {
  final String type;
  List<ToolboxBlockData> fields = [];

  ToolboxBlock({this.type = ''});

  factory ToolboxBlock.fromJson(Map<String, dynamic> json) {
    return ToolboxBlock();
  }

  Map<String, dynamic> toJson() {
    final xml = getBlockXml();

    if (xml.isEmpty) {
      return {
        'kind': 'block',
        'type': type,
      };
    }

    return {
      'kind': 'block',
      'blockxml': getBlockXml(),
    };
  }

String getBlockXml() {

    if (fields.isEmpty) {
      return '';
    }

    String xmlContent = fields.map((e) => e.getXml()).join();
    return '<block type="$type">$xmlContent</block>';
  }

  ToolboxBlock addField(String name, String type) {
    fields.add(ToolboxBlockField(name: name, type: type));
    return this;
  }

  ToolboxBlock addShadow(String type, ToolboxBlockField field) {
    fields.add(ToolboxBlockShadow(type: type, field: field));
    return this;
  }

  ToolboxBlock addValue(String name, ToolboxBlockData data) {
    fields.add(ToolboxBlockValue(name: name, data: data));
    return this;
  }

  ToolboxBlock addMutation({
    bool? divisorInput,
    String? op,
    bool? at,
    String? items,
    bool? at2,
    bool? at1,
    String? type,
    bool? statement,
    String? mode,
  }) {
    fields.add(ToolboxBlockMutation(
        divisor_input: divisorInput,
        op: op,
        at: at,
        items: items,
        at2: at2,
        at1: at1,
        type: type,
        statement: statement,
        mode: mode
    ));
    return this;
  }

  ToolboxBlock addBlock(ToolboxBlock block) {
    fields.add(block);
    return this;
  }
}