import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// A class that represents a physical body with gravity.
class GravityComponent extends BodyComponent {
  final Vector2 gravity;

  GravityComponent({required this.gravity});

  @override
  Body createBody() {
    // Define the body as dynamic (affected by forces)
    final bodyDef = BodyDef(type: BodyType.dynamic);
    bodyDef.position = Vector2(0, 0); // Initial position

    // Create the body
    final body = world.createBody(bodyDef);

    // Add a circular fixture for simplicity
    final shape = CircleShape()..radius = 1.0;
    final fixtureDef = FixtureDef(shape, density: 1.0, friction: 0.5, restitution: 0.5);
    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity force on both x and y axes
    body.applyForceToCenter(gravity);
  }
}

/// A Forge2D game that displays a component affected by gravity.
class GravityGame extends Forge2DGame {
  GravityGame() : super(gravity: Vector2(0, 0)); // No global gravity, custom applied.

  @override
  Future<void> onLoad() async {
    // Adding the GravityComponent to the game with gravity on both x and y axes
    add(GravityComponent(gravity: Vector2(0, 10))); // Gravity of 10 units in the Y-axis
    add(GravityComponent(gravity: Vector2(5, 0)));  // Gravity of 5 units in the X-axis
  }
}

void main() {
  runApp(GameWidget(game: GravityGame()));
}
