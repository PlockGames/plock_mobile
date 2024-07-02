import 'package:flame/components.dart';

/// The component to display the game objects and when the are selected.
class DisplayComponents {
  /// The component to display the object.
  late Component? display;
  /// The component to display when the object is selected.
  late ShapeComponent? select;

  DisplayComponents({this.display, this.select});
}