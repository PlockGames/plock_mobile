import 'package:plock_mobile/models/component_fields/blocky/toolbox_block.dart';

/// A category of blocks for blockly.
///
/// Used in blockly toolbox.
class ToolboxCategory {
  final String name;
  final List<ToolboxBlock>? blocks;
  final int color;
  final String? custom;

  ToolboxCategory({required this.name, this.blocks, this.color = 0, this.custom});

  /// Convert the [ToolboxCategory] to a json.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'kind': 'category',
      'name': name,
      'colour': color,
    };

    if (custom != null) {
      result['custom'] = custom;
    }

    if (blocks != null) {
      result['contents'] = blocks!.map((e) => e.toJson()).toList();
    }

    return result;
  }
}