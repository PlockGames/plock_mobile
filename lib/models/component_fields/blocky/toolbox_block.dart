/// ToolboxBlock is a class that contains the data of a block in the toolbox.
class ToolboxBlock {

  final Map<String, dynamic> data;

  ToolboxBlock({required this.data});

  /// Creates a ToolboxBlockData from a json.
  factory ToolboxBlock.fromJson(Map<String, dynamic> json) {
    return ToolboxBlock(data: json);
  }

  /// Converts the ToolboxBlockData to a json.
  Map<String, dynamic> toJson() {
    return data;
  }
}