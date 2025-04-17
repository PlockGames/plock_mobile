import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_editor_page.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/component_field_sprite.dart';

void main() {
  group('ComponentFieldSprite', () {
    late ComponentFieldSprite componentFieldSprite;
    List<PlockSpriteAnimation> initialAnimations = [
      PlockSpriteAnimation(name: 'Animation 1'),
      PlockSpriteAnimation(name: 'Animation 2'),
    ];

    setUp(() {
      componentFieldSprite = ComponentFieldSprite(
        value: initialAnimations,
        onUpdate: () {},
      );
    });

    test('constructor initializes correctly', () {
      expect(componentFieldSprite.value, equals(initialAnimations));
      expect(componentFieldSprite.type, equals('ComponentFieldText'));
    });
/*
    test('toJson method generates correct JSON', () {
      String jsonResult = componentFieldSprite.toJson();
      expect(jsonResult, contains('"name":"Animation 1"'));
      expect(jsonResult, contains('"name":"Animation 2"'));
    });
    test('updateFromJson method updates value correctly', () {
      List<dynamic> jsonData = [
        {'name': 'New Animation 1'},
        {'name': 'New Animation 2'},
      ];

      componentFieldSprite.updateFromJson(jsonData);

      expect(componentFieldSprite.value.length, equals(2));
      expect(componentFieldSprite.value[0].name, equals('New Animation 1'));
      expect(componentFieldSprite.value[1].name, equals('New Animation 2'));
    });
*/

    test('instance method creates a copy', () {
      ComponentFieldSprite instanceCopy = componentFieldSprite.instance();

      expect(instanceCopy.value.length, equals(componentFieldSprite.value.length));
      expect(instanceCopy.value[0].name, equals(componentFieldSprite.value[0].name));
      expect(instanceCopy, isNot(same(componentFieldSprite)));
    });
  });

  group('ComponentFieldSpriteField Widget', () {
    testWidgets('renders initial animations', (WidgetTester tester) async {
      final List<PlockSpriteAnimation> animations = [
        PlockSpriteAnimation(name: 'Animation 1'),
        PlockSpriteAnimation(name: 'Animation 2'),
      ];

      final ComponentFieldSprite componentFieldSprite = ComponentFieldSprite(
        value: animations,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldSprite.getField('Sprite Field', false, [], {}),
          ),
        ),
      );

      // Vérifier que les animations sont affichées
      expect(find.text('Animation 1'), findsOneWidget);
      expect(find.text('Animation 2'), findsOneWidget);
    });

    testWidgets('can add new animation', (WidgetTester tester) async {
      final List<PlockSpriteAnimation> animations = [
        PlockSpriteAnimation(name: 'Animation 1'),
      ];
      bool updateCalled = false;

      final ComponentFieldSprite componentFieldSprite = ComponentFieldSprite(
        value: animations,
        onUpdate: () {
          updateCalled = true;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldSprite.getField('Sprite Field', false, [], {}),
          ),
        ),
      );

      // Trouver et appuyer sur le bouton d'ajout
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Vérifier qu'une nouvelle animation a été ajoutée
      expect(componentFieldSprite.value.length, equals(2));
      expect(componentFieldSprite.value.last.name, equals('New Animation'));
      expect(updateCalled, isTrue);
    });

    testWidgets('can remove an animation', (WidgetTester tester) async {
      final List<PlockSpriteAnimation> animations = [
        PlockSpriteAnimation(name: 'Animation 1'),
        PlockSpriteAnimation(name: 'Animation 2'),
      ];
      bool updateCalled = false;

      final ComponentFieldSprite componentFieldSprite = ComponentFieldSprite(
        value: animations,
        onUpdate: () {
          updateCalled = true;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldSprite.getField('Sprite Field', false, [], {}),
          ),
        ),
      );

      // Trouver et appuyer sur le premier bouton de suppression
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();

      // Vérifier qu'une animation a été supprimée
      expect(componentFieldSprite.value.length, equals(1));
      expect(componentFieldSprite.value.first.name, equals('Animation 2'));
      expect(updateCalled, isTrue);
    });

    testWidgets('navigates to SpriteEditorPage when tapping an animation', (WidgetTester tester) async {
      final List<PlockSpriteAnimation> animations = [
        PlockSpriteAnimation(name: 'Animation 1'),
      ];

      final ComponentFieldSprite componentFieldSprite = ComponentFieldSprite(
        value: animations,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentFieldSprite.getField('Sprite Field', false, [], {}),
          ),
        ),
      );

      // Trouver et appuyer sur l'animation
      await tester.tap(find.text('Animation 1'));
      await tester.pumpAndSettle();

      // Vérifier que la navigation vers SpriteEditorPage a été déclenchée
      expect(find.byType(SpriteEditorPage), findsOneWidget);
    });
  });
}