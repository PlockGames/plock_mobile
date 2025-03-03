import 'dart:async';

import 'package:plock_mobile/models/games/component_type.dart';

import 'media.dart';

abstract class ComponentFlame {
  ComponentType getComponentType();
  void move(double x, double y) {}
  bool isFullyLoaded() {
    return true;
  }
}