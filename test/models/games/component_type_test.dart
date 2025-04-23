import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/component_type.dart';
import 'package:plock_mobile/models/games/display_components.dart';
import 'package:plock_mobile/pages/play/game_player_object.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/game_object.dart';
import 'package:plock_mobile/models/games/game.dart';

void main() {
  group('ComponentType', () {
    late ComponentType componentType;

    setUp(() {
      componentType = ComponentType();
    });

    test('uuid is initialized', () {
      expect(componentType.uuid, isNotEmpty);
    });

    test('type returns "Component"', () {
      expect(componentType.type, 'Component');
    });

    test('name returns "Unknown"', () {
      expect(componentType.name, 'Unknown');
    });

    test('debugData returns an empty map', () {
      expect(componentType.debugData, {});
    });

    test('instance creates a copy with same fields', () {
      final field = ComponentField();
      componentType.fields['testField'] = field;
      final copy = componentType.instance();
      expect(copy.fields['testField'], isNotNull);
      expect(copy.fields['testField'].runtimeType, field.runtimeType);
    });

    test('getDisplayComponent returns DisplayComponents', () {
      final displayComponent = componentType.getDisplayComponent([], () {}, () {}, () {}, () {}, () {});
      expect(displayComponent, isA<DisplayComponents>());
    });

    test('getGameDisplayComponent returns null', () {
      final gameDisplayComponent = componentType.getGameDisplayComponent([], () {}, () {}, () {}, () {}, () {});
      expect(gameDisplayComponent, isNull);
    });


    test('setOnUpdate sets onUpdate for all fields', () {
      final field1 = ComponentField();
      final field2 = ComponentField();
      componentType.fields['field1'] = field1;
      componentType.fields['field2'] = field2;

      final onUpdateFunction = () {};
      componentType.setOnUpdate(onUpdateFunction);

      expect(field1.onUpdate, onUpdateFunction);
      expect(field2.onUpdate, onUpdateFunction);
    });

  });
}