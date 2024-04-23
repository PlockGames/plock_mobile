import 'package:plock_mobile/models/component_fields/blocky/toolbox_category.dart';

class Toolbox {
  final List<ToolboxCategory> categories;

  Toolbox({required this.categories});

  factory Toolbox.fromJson(Map<String, dynamic> json) {
    return Toolbox(
      categories: (json['categories'] as List)
          .map((e) => ToolboxCategory.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': 'categoryToolbox',
      'contents': categories.map((e) => e.toJson()).toList(),
    };
  }
}