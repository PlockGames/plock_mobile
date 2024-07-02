import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_data.dart';

/// A field in a block.
class ToolboxBlockField extends ToolboxBlockData {
  /// Name of the field
  final String name;
  /// Type of the field
  final String type;

  ToolboxBlockField({required this.name, required this.type});

  factory ToolboxBlockField.fromJson(Map<String, dynamic> json) {
    return ToolboxBlockField(
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }

  @override
  String getXml() {
    return '<field name="$name">$type</field>';
  }
}