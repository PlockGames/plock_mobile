import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/models/component_fields/component_field_image.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/component_fields/image/media_select.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'package:image_picker/image_picker.dart'; // Assurez-vous d'importer XFile

void main() {
  group('ComponentFieldImage Tests', () {
    test('Should create ComponentFieldImage with default values', () {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final imageField = ComponentFieldImage(value: mediaSelect);

      expect(imageField.type, 'ComponentFieldText');
      expect(imageField.value.name, 'image1');
      expect(imageField.value.index, 0);
    });

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
/*

    testWidgets('Should update value on text change', (WidgetTester tester) async {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final imageField = ComponentFieldImage(value: mediaSelect);
      final medias = [Media(id: 1, name: 'image1'), Media(id: 2, name: 'image2')];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ComponentFieldImageField(field: imageField, name: 'Image', medias: medias),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'image2');
      await tester.pumpAndSettle();

      // Ensure the value is updated in the field
      expect(imageField.value.name, 'image2');
    });
    testWidgets('Should display image correctly', (WidgetTester tester) async {
      final mediaSelect = MediaSelect()
        ..name = 'image1'
        ..index = 0;
      final imageField = ComponentFieldImage(value: mediaSelect);
      final media = Media(id: 1, name: 'image1', file: XFile.fromData(Uint8List(0)));
      final medias = [media];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ComponentFieldImageField(field: imageField, name: 'Image', medias: medias),
        ),
      ));

      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
    });

 */
  });
}
