import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_image.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/image/media_select.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/component_fields/image/part_image.dart';

void main() {
  group('ComponentFieldImage Tests', () {


    test('Should update value correctly', () {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final imageField = ComponentFieldImage(value: mediaSelect);
      final newMediaSelect = MediaSelect()
        ..name = 'image2'
        ..index = 1;
      imageField.value = newMediaSelect;

      expect(imageField.value.name, 'image2');
      expect(imageField.value.index, 1);
    });

    test('Should create an instance with the same values', () {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final originalField = ComponentFieldImage(value: mediaSelect);
      final instanceField = originalField.instance();

      expect(instanceField.value.name, originalField.value.name);
      expect(instanceField.value.index, originalField.value.index);
      expect(instanceField.onUpdate, originalField.onUpdate);
    });

    test('Should convert value to JSON correctly', () {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final imageField = ComponentFieldImage(value: mediaSelect);
      final json = imageField.toJson();

      expect(json, '{"name": "image1","index": 0}');
    });

    test('Should update from JSON correctly', () {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final imageField = ComponentFieldImage(value: mediaSelect);
      final jsonVal = {'name': 'image2', 'index': 1};
      imageField.updateFromJson(jsonVal);

      expect(imageField.value.name, 'image2');
      expect(imageField.value.index, 1);
    });

    test('Should set and get the value correctly', () {
      final imageField = ComponentFieldImage(value: MediaSelect());
      final newValue = MediaSelect()
        ..name = 'new_image'
        ..index = 5;
      imageField.value = newValue;
      expect(imageField.value.name, 'new_image');
      expect(imageField.value.index, 5);
    });

    test('Should handle onUpdate callback when provided', () {
      bool onUpdateCalled = true;
      final imageField = ComponentFieldImage(
        value: MediaSelect(),
        onUpdate: () {
          onUpdateCalled = true;
        },
      );
      imageField.value = MediaSelect()
        ..name = 'updated_image'
        ..index = 2;
      expect(onUpdateCalled, true);
    });

    test('Should handle null onUpdate callback', () {
      final imageField = ComponentFieldImage(value: MediaSelect());
      expect(() => imageField.value = MediaSelect()..name = 'test', returnsNormally);
    });
  });

  group('ComponentFieldImageField Widget Tests', () {
    testWidgets('Should display initial value correctly', (WidgetTester tester) async {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final imageField = ComponentFieldImage(value: mediaSelect);
      final medias = [Media(id: 1, name: 'image1')];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ComponentFieldImageField(field: imageField, name: 'Image', medias: medias),
        ),
      ));

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      final textFieldContent = tester.widget<TextField>(textField).controller?.text;
      expect(textFieldContent, 'image1');
    });

  });
}