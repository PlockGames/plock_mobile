/// A class that represents a 2D vector.
class Vector2 {
  late double x;
  late double y;

  Vector2(this.x, this.y);

  String toJson() {
    return '{"x": $x, "y": $y}';
  }

  /// Create a Vector2 from a JSON object.
  static Vector2 fromJson(Map<String, dynamic> json) {
    return Vector2(json['x'].toDouble(), json['y'].toDouble());
  }
}