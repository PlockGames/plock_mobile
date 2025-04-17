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

    // Test size field
    final sizeField = componentImage.fields['size'];
    expect(sizeField, isNotNull);
    expect(sizeField, isA<ComponentFieldNumber>());
    expect((sizeField as ComponentFieldNumber).value, 1.0);

    // Test texture field
    final textureField = componentImage.fields['texture'];
    expect(textureField, isNotNull);
    expect(textureField.runtimeType.toString(), 'ComponentFieldImage');
    expect((textureField as dynamic).value, isA<MediaSelect>());
  });

  test('Instance method creates a new ComponentImage with copied fields', () {
    // Modify fields
    (componentImage.fields['size'] as ComponentFieldNumber).value = 2.0;
    (componentImage.fields['texture'] as dynamic).value = MediaSelect();

    final newInstance = componentImage.instance() as ComponentImage;

    expect(newInstance, isA<ComponentImage>());
    expect((newInstance.fields['size'] as ComponentFieldNumber).value, 2.0);
    expect((newInstance.fields['texture'] as dynamic).value, isA<MediaSelect>());
    expect(newInstance, isNot(same(componentImage)));
  });

  test('getGameDisplayComponent returns null when no texture is provided', () {
    final result = componentImage.getGameDisplayComponent(
      [], // empty media list
      null, null, null, null, null,
    );

    expect(result, isNull);
  });
}