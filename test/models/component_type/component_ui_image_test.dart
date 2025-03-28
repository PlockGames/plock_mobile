import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_types/component_ui_image.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_image.dart';
import 'package:plock_mobile/pages/play/game_player_object.dart';

void main() {
  group('ComponentUiImage', () {
    late ComponentUiImage componentUiImage;

    setUp(() {
      componentUiImage = ComponentUiImage();
    });

    test('should initialize with correct default fields', () {
      expect(componentUiImage.fields.containsKey('size'), isTrue);
      expect(componentUiImage.fields.containsKey('texture'), isTrue);
      expect(componentUiImage.type, 'ComponentUiImage');
      expect(componentUiImage.name, 'Image');
    });



    test('getDisplayComponent should handle null texture', () {
      final result = componentUiImage.getDisplayComponent(
          [],
              () {}, () {}, () {}, () {}, () {}
      );
      expect(result.display, isNull);
      expect(result.select, isNull);
    });

    test('getGameDisplayComponent should handle null texture', () {
      final result = componentUiImage.getGameDisplayComponent(
          [],
              () {}, () {}, () {}, () {}, () {}
      );
      expect(result, isNull);
    });


  });
}