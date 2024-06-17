import 'dart:ui';

import 'package:flame/components.dart';

import '../../models/games/game_object.dart';

class GamePlayerObject extends PositionComponent {

  late GameObject gameObject;

  List<Component> displayComponents = [];

  String name = 'Object';

  GamePlayerObject({
    required this.gameObject
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(0, 0);
    position = Vector2(gameObject.position.x, gameObject.position.y);
    updateDisplay();
  }

  void updateDisplay() {
    for (var component in displayComponents) {
      remove(component);
    }
    displayComponents = [];

    for (var component in gameObject.components) {
      ShapeComponent? displayComponent = component.getGameDisplayComponent();
      if (displayComponent != null) {
        displayComponents.add(displayComponent);
        add(displayComponent);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
