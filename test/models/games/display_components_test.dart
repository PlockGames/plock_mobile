import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:plock_mobile/models/games/display_components.dart'; // Ajustez le chemin selon votre projet

void main() {
  group('DisplayComponents', () {
    test('should initialize with null values by default', () {
      final components = DisplayComponents();

      expect(components.display, isNull);
      expect(components.select, isNull);
    });

    test('should initialize with provided display component', () {
      final displayComponent = Component();
      final components = DisplayComponents(display: displayComponent);

      expect(components.display, equals(displayComponent));
      expect(components.select, isNull);
    });

    test('should initialize with provided select component', () {
      final selectComponent = RectangleComponent();
      final components = DisplayComponents(select: selectComponent);

      expect(components.display, isNull);
      expect(components.select, equals(selectComponent));
    });

    test('should initialize with both components', () {
      final displayComponent = Component();
      final selectComponent = RectangleComponent();
      final components = DisplayComponents(
        display: displayComponent,
        select: selectComponent,
      );

      expect(components.display, equals(displayComponent));
      expect(components.select, equals(selectComponent));
    });

    test('should allow changing display component', () {
      final components = DisplayComponents();
      final newDisplay = Component();

      components.display = newDisplay;
      expect(components.display, equals(newDisplay));
    });

    test('should allow changing select component', () {
      final components = DisplayComponents();
      final newSelect = RectangleComponent();

      components.select = newSelect;
      expect(components.select, equals(newSelect));
    });
  });
}