import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/models/games/game.dart' as Plock;
import 'package:plock_mobile/models/games/game_object.dart';

import '../../../../models/component_types/component_rect.dart';
import 'editor_mode.dart';

/// A flame object that represents a component in the game editor.
mixin ObjectComponent {

  GameObject getGameObject();
  updateDisplay();


}
