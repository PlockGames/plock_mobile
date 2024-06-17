class Vector2 {
  late double x;
  late double y;

  Vector2(this.x, this.y);

  String toJson() {
    return '{"x": $x, "y": $y}';
  }
}