import 'package:plock_mobile/models/component_fields/blocky/toolbox_category.dart';

class Toolbox {
  final List<ToolboxCategory> categories;

  Toolbox({required this.categories});

  /// Convert the [Toolbox] to a json.
  Map<String, dynamic> toJson() {
    return {
      'kind': 'categoryToolbox',
      'contents': categories.map((e) => e.toJson()).toList(),
    };
  }
}