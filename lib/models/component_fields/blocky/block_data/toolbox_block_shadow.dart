import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_data.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';

class ToolboxBlockShadow extends ToolboxBlockData {
  final String type;
  final ToolboxBlockField field;

  ToolboxBlockShadow({required this.type, required this.field});

  factory ToolboxBlockShadow.fromJson(Map<String, dynamic> json) {
    return ToolboxBlockShadow(
      type: json['type'],
      field: ToolboxBlockField.fromJson(json['field']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'field': field.toJson(),
    };
  }

  @override
  String getXml() {
    return '<shadow type="$type">${field.getXml()}</shadow>';
  }

}
