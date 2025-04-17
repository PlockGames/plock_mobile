import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/tilemap/tilemap_editor_controller.dart';

void main() {
  late TilemapEditorController controller;

  setUp(() {
    // Initialisation du contrôleur avec un tileSize de 32
    controller = TilemapEditorController(tileSize: 32);
  });

  test('TilemapEditorController has correct initial values', () {
    // Vérification que le paramètre tileSize est bien initialisé à 32
    expect(controller.tileSize, 32);

    // Vérification que les valeurs initiales de x et y sont bien à 0
    expect(controller.x, 0);
    expect(controller.y, 0);
  });

  test('TilemapEditorController x and y are mutable', () {
    // Modifier les valeurs de x et y
    controller.x = 10;
    controller.y = 20;

    // Vérification que les valeurs de x et y ont bien été mises à jour
    expect(controller.x, 10);
    expect(controller.y, 20);
  });
}
