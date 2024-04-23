import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_data.dart';
import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_shadow.dart';

class ToolboxBlockValue extends ToolboxBlockData {
  final String name;
  final ToolboxBlockData data;

  ToolboxBlockValue({required this.name, required this.data});

  factory ToolboxBlockValue.fromJson(Map<String, dynamic> json) {
    return ToolboxBlockValue(
      name: json['name'],
      data: ToolboxBlockShadow.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data.toJson(),
    };
  }

  @override
  String getXml() {
    return '<value name="$name">${data.getXml()}</value>';
  }

}