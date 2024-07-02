import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_data.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_field.dart';

/// A shadow in a block.
class ToolboxBlockShadow extends ToolboxBlockData {
  /// Type of the shadow
  final String type;
  /// Field of the shadow
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
