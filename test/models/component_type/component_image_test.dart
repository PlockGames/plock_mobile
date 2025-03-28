import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_types/component_image.dart';
import 'package:plock_mobile/models/component_fields/component_field_number.dart';
import 'package:plock_mobile/models/component_fields/component_field_image.dart';
import 'package:plock_mobile/models/component_fields/image/media_select.dart';

void main() {
  late ComponentImage componentImage;

  setUp(() {
    componentImage = ComponentImage();
  });

  test('ComponentImage initializes with correct default fields', () {
    expect(componentImage.type, 'ComponentImage');
    expect(componentImage.name, 'Image');

    expect(componentImage.fields['size'], isA<ComponentFieldNumber>());
    expect(componentImage.fields['size']!.value, 1.0);

    expect(componentImage.fields['texture'], isA<ComponentFieldImage>());
    expect(componentImage.fields['texture']!.value, isA<MediaSelect>());
  });

  test('Instance method creates a new ComponentImage with copied fields', () {
    // Modify fields with default MediaSelect constructor
    componentImage.fields['size']!.value = 2.0;
    componentImage.fields['texture']!.value = MediaSelect();

    ComponentImage newInstance = componentImage.instance() as ComponentImage;

    expect(newInstance, isA<ComponentImage>());
    expect(newInstance.fields['size']!.value, 2.0);
    expect(newInstance.fields['texture']!.value, isA<MediaSelect>());
    expect(newInstance, isNot(same(componentImage)));
  });

  test('getGameDisplayComponent method handles null texture', () {
    final result = componentImage.getGameDisplayComponent(
        [], // empty media list
        null, null, null, null, null
    );

    expect(result, isNull);
  });
}