import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plock_mobile/models/games/component_field.dart';
import 'package:plock_mobile/models/component_fields/component_field_texture.dart';

void main() {
  group('ComponentFieldTexture', () {
    late XFile testXFile;

    setUp(() {
      // Créer un fichier temporaire pour les tests
      final file = File('test_image.jpg');
      file.writeAsBytesSync(List.generate(100, (index) => 0));
      testXFile = XFile(file.path);
    });

    tearDown(() {
      // Nettoyer le fichier temporaire
      try {
        File(testXFile.path).deleteSync();
      } catch (e) {
        // Ignorer les erreurs si le fichier n'existe pas
      }
    });

    testWidgets('renders TextureField with initial null value', (tester) async {
      final componentField = ComponentFieldTexture(
        value: null,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentField.getField('Texture', false, [], {}),
          ),
        ),
      );

      expect(find.text('Pick Image'), findsOneWidget);
      expect(find.text('No image selected'), findsOneWidget);
    });

    testWidgets('renders TextureField with initial image', (tester) async {
      final componentField = ComponentFieldTexture(
        value: testXFile,
        onUpdate: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: componentField.getField('Texture', false, [], {}),
          ),
        ),
      );

      expect(find.text('Pick Image'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });


    test('instance creates a copy with same values', () {
      bool updateCalled = false;

      final original = ComponentFieldTexture(
        value: testXFile,
        onUpdate: () {
          updateCalled = true;
        },
      );

      final copy = original.instance();

      expect(copy.value, testXFile);
      expect(copy.type, 'ComponentFieldTexture');

      // Vérifier que le callback est bien copié
      copy.onUpdate!();
      expect(updateCalled, true);
    });

    test('updateValue updates the internal value', () {
      final newXFile = XFile('new_image.jpg');
      final field = ComponentFieldTexture(value: testXFile, onUpdate: () {});

      expect(field.value, testXFile);
      field.updateValue(newXFile);
      expect(field.value, newXFile);
    });

    test('value setter updates internal value', () {
      final newXFile = XFile('new_image.jpg');
      final field = ComponentFieldTexture(value: testXFile, onUpdate: () {});

      expect(field.value, testXFile);
      field.value = newXFile;
      expect(field.value, newXFile);
    });
  });
}

// Fake ImagePicker pour simuler la sélection d'image
class _FakeImagePicker extends ImagePicker {
  final XFile fileToReturn;

  _FakeImagePicker(this.fileToReturn);

  @override
  Future<XFile?> pickImage({
    ImageSource? source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return fileToReturn;
  }
}