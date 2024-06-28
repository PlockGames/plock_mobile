/// ToolboxBlockData is a class that contains the data of a block in the toolbox.
class ToolboxBlockData {

  ToolboxBlockData();

  /// Returns the xml representation of the block.
  String getXml() {
    return '';
  }

  /// Creates a ToolboxBlockData from a json.
  factory ToolboxBlockData.fromJson(Map<String, dynamic> json) {
    return ToolboxBlockData();
  }

  /// Converts the ToolboxBlockData to a json.
  Map<String, dynamic> toJson() {
    return {};
  }
}