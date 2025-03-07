class MediaSelect {
  String name = '';
  int index = 0;

  MediaSelect();

  MediaSelect.fromJson(Map<String, dynamic> json) : name = json['name'], index = json['index'];

  String toJson() {
    return """
    {
      "name": "$name",
      "index": $index
    }
    """;
  }
}