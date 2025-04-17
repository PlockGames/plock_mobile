import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_flame.dart';
import 'package:plock_mobile/models/games/component_type.dart';

// Concrete implementation of ComponentFlame for testing
class ConcreteComponentFlame extends ComponentFlame {
  @override
  ComponentType getComponentType() {
    return ComponentType();
  }

  double x = 0;
  double y = 0;

  @override
  void move(double x, double y) {
    this.x = x;
    this.y = y;
  }

  bool loaded = true;

  @override
  bool isFullyLoaded() {
    return loaded;
  }

  void setLoaded(bool loaded) {
    this.loaded = loaded;
  }
}

void main() {
  group('ComponentFlame', () {
    late ConcreteComponentFlame componentFlame;

    setUp(() {
      componentFlame = ConcreteComponentFlame();
    });

    test('getComponentType returns a ComponentType instance', () {
      final type = componentFlame.getComponentType();
      expect(type, isA<ComponentType>());
    });

    test('move method updates x and y', () {
      componentFlame.move(10.0, 20.0);
      expect(componentFlame.x, 10.0);
      expect(componentFlame.y, 20.0);
    });

    test('isFullyLoaded returns true by default', () {
      expect(componentFlame.isFullyLoaded(), true);
    });

    test('isFullyLoaded can return false', () {
      componentFlame.setLoaded(false);
      expect(componentFlame.isFullyLoaded(), false);
      componentFlame.setLoaded(true);
      expect(componentFlame.isFullyLoaded(), true);
    });
  });
}