import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plock_mobile/models/component_fields/image/LoadedImage.dart';
import 'package:plock_mobile/models/component_fields/image/media_select.dart';
import 'package:plock_mobile/models/component_fields/image/part_image.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_editor_page.dart';
import 'package:plock_mobile/models/component_fields/sprite/sprite_animation.dart';
import 'package:plock_mobile/models/games/media.dart';
import 'package:plock_mobile/models/games/media/media_set.dart';
import 'dart:typed_data';
import 'dart:convert';

// Une image de test en Base64 (un pixel noir 1x1)
const String kTestImageBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';
final Uint8List kTestImageData = base64Decode(kTestImageBase64);

// Create a Mock for Media class
class MockMedia extends Mock implements Media {
  final String name;

  MockMedia(this.name);

  @override
  Future<LoadedImage?> getLoadedImage({int? index}) async {
    return LoadedImage(data: kTestImageData, bounds: Rect.zero);
  }

  @override
  String toString() => 'MockMedia(name: $name)';
}

void main() {
  group('SpriteEditorPage', () {
    late PlockSpriteAnimation testSprite;
    late List<Media> testMedias;
    Function? onUpdateCallback;
    bool onUpdateCalled = false;

    setUp(() {
      testSprite = PlockSpriteAnimation(name: 'Test Sprite');
      testSprite.images.add(MediaSelect()..name = 'image1.png'..index = 0);
      testSprite.images.add(MediaSelect()..name = 'tileset1.png'..index = 2);

      testMedias = [
        MockMedia('image1.png'),
        MockMedia('other.png'),
        MockMedia('tileset1.png'),
      ];
      expect(testMedias, isNotNull);
      expect(testMedias, isNotEmpty);

      onUpdateCalled = false;
      onUpdateCallback = () {
        onUpdateCalled = true;
      };
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: SpriteEditorPage(
          sprite: testSprite,
          onUpdate: onUpdateCallback,
          medias: testMedias,
        ),
      );
    }

    testWidgets('updates sprite name when text field changes', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      const newName = 'New Sprite Name';
      await tester.enterText(find.byWidgetPredicate((widget) => widget.runtimeType == TextField && (widget as TextField).decoration?.labelText == 'Name'), newName);
      await tester.pump();

      expect(testSprite.name, newName);
      expect(onUpdateCalled, isTrue);
    });


    testWidgets('removes image when delete button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();

      expect(testSprite.images.length, 1);
      expect(testSprite.images[0].name, 'tileset1.png');
      expect(onUpdateCalled, isTrue);
    });

    testWidgets('adds new media select when add button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(testSprite.images.length, 3);
      expect(testSprite.images.last.name, '');
      expect(testSprite.images.last.index, 0);
      expect(onUpdateCalled, isTrue);
    });

    testWidgets('displays PartImage for valid media', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for FutureBuilder to complete

      expect(find.byType(PartImage), findsNWidgets(2));
    });

  });
}