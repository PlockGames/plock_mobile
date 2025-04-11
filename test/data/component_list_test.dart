import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/data/ComponentList.dart';
import 'package:plock_mobile/models/component_types/component_circle.dart';
import 'package:plock_mobile/models/component_types/component_event.dart';
import 'package:plock_mobile/models/component_types/component_image.dart';
import 'package:plock_mobile/models/component_types/component_list.dart' as cp;
import 'package:plock_mobile/models/component_types/component_physics.dart';
import 'package:plock_mobile/models/component_types/component_physics_circle.dart';
import 'package:plock_mobile/models/component_types/component_rect.dart';
import 'package:plock_mobile/models/component_types/component_sprite.dart';
import 'package:plock_mobile/models/component_types/component_text.dart';
import 'package:plock_mobile/models/component_types/component_tilemap.dart';
import 'package:plock_mobile/models/component_types/component_ui_image.dart';
import 'package:plock_mobile/models/component_types/component_ui_text.dart';
import 'package:plock_mobile/models/component_types/component_variable.dart';

void main() {
  group('ComponentList Tests', () {
    test('Should return all components in a map', () {
      final components = ComponentList.getAll();

      expect(components, isMap);
      expect(components.length, greaterThan(0));
    });

    test('Should return scene components in a map', () {
      final sceneComponents = ComponentList.getScene();

      expect(sceneComponents, isMap);
      expect(sceneComponents.length, greaterThan(0));
      expect(sceneComponents.containsKey('ComponentRect'), isTrue);
      expect(sceneComponents.containsKey('ComponentUiText'), isFalse);
    });

    test('Should return UI components in a map', () {
      final uiComponents = ComponentList.getUi();

      expect(uiComponents, isMap);
      expect(uiComponents.length, greaterThan(0));
      expect(uiComponents.containsKey('ComponentUiText'), isTrue);
      expect(uiComponents.containsKey('ComponentRect'), isFalse);
    });

    test("Should return correct components by name", () {
      // Test scene components
      expect(ComponentList.getByName("ComponentRect"), isA<ComponentRect>());
      expect(ComponentList.getByName("ComponentCircle"), isA<ComponentCircle>());
      expect(ComponentList.getByName("ComponentText"), isA<ComponentText>());
      expect(ComponentList.getByName("ComponentEvent"), isA<ComponentEvent>());
      expect(ComponentList.getByName("ComponentVariable"), isA<ComponentVariable>());
      expect(ComponentList.getByName("ComponentList"), isA<cp.ComponentList>());
      expect(ComponentList.getByName("ComponentImage"), isA<ComponentImage>());
      expect(ComponentList.getByName("ComponentSprite"), isA<ComponentSprite>());
      expect(ComponentList.getByName("ComponentPhysics"), isA<ComponentPhysics>());
      expect(ComponentList.getByName("ComponentPhysicsCircle"), isA<ComponentPhysicsCircle>());
      expect(ComponentList.getByName("ComponentTilemap"), isA<ComponentTilemap>());

      // Test UI components
      expect(ComponentList.getByName("ComponentUiText"), isA<ComponentUiText>());
      expect(ComponentList.getByName("ComponentUiImage"), isA<ComponentUiImage>());
    });

    test('Should return null for non-existent component', () {
      expect(ComponentList.getByName("NonExistentComponent"), isNull);
    });

    test('All components map contains both scene and UI components', () {
      final allComponents = ComponentList.getAll();
      final sceneComponents = ComponentList.getScene();
      final uiComponents = ComponentList.getUi();

      // Vérifier que tous les composants de scène sont dans la liste complète
      for (var key in sceneComponents.keys) {
        expect(allComponents.containsKey(key), isTrue);
      }

      // Vérifier que tous les composants UI sont dans la liste complète
      for (var key in uiComponents.keys) {
        expect(allComponents.containsKey(key), isTrue);
      }

      // Vérifier que la longueur du map complet est cohérente (en tenant compte des doublons)
      int expectedLength = sceneComponents.length + uiComponents.length;
      // Compter les doublons (clés présentes dans les deux maps)
      int duplicates = 0;
      for (var key in sceneComponents.keys) {
        if (uiComponents.containsKey(key)) {
          duplicates++;
        }
      }
      expectedLength -= duplicates;

      expect(allComponents.length, equals(expectedLength));
    });
  });
}