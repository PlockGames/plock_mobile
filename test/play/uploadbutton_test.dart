import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/pages/play/uploadbutton.dart';
import 'package:flame/events.dart';
import 'package:flutter/gestures.dart';

class MockGame extends FlameGame {}

class MockTapUpDetails implements TapUpDetails {
  @override
  final Offset globalPosition;

  @override
  final Offset localPosition;

  @override
  final PointerDeviceKind kind;

  MockTapUpDetails({
    Offset? globalPosition,
    Offset? localPosition,
    PointerDeviceKind? kind,
  })  : globalPosition = globalPosition ?? Offset.zero,
        localPosition = localPosition ?? Offset.zero,
        kind = kind ?? PointerDeviceKind.touch;
}

void main() {
  group('UploadButton', () {
    test('initializes with correct properties', () {
      // Prepare test data
      final screenSize = Vector2(800, 600);

      // Flag to track upload function call
      bool uploadCalled = false;

      // Create the button
      final uploadButton = UploadButton(
        uploadGame: () {
          uploadCalled = true;
        },
        screenSize: screenSize,
      );

      // Simulate component loading
      uploadButton.onLoad();

      // Verify initial text
      expect(uploadButton.text, equals('Upload'));

      // Verify positioning
      expect(uploadButton.x, equals(screenSize.x - 50));
      expect(uploadButton.y, equals(50));

      // Verify anchor
      expect(uploadButton.anchor, equals(Anchor.topRight));

      // Verify text style
      expect(uploadButton.textRenderer, isNotNull);
    });

    test('triggers upload callback on tap', () {
      // Prepare test data
      final screenSize = Vector2(800, 600);

      // Flag to track upload function call
      bool uploadCalled = false;

      // Create the button
      final uploadButton = UploadButton(
        uploadGame: () {
          uploadCalled = true;
        },
        screenSize: screenSize,
      );

      // Create mock game and tap details
      final mockGame = MockGame();
      final mockTapDetails = MockTapUpDetails();

      // Simulate component loading
      uploadButton.onLoad();

      // Create tap event
      final tapEvent = TapUpEvent(
          0, // pointerId
          mockGame,
          mockTapDetails
      );

      // Invoke onTapUp method with event
      final bool tapResult = uploadButton.onTapUp(tapEvent);

      // Verify upload function was called
      expect(uploadCalled, isTrue);

      // Verify tap was handled
      expect(tapResult, isTrue);
    });

    test('maintains correct positioning across different screen sizes', () {
      // Test various screen sizes
      final testCases = [
        Vector2(1000, 800),
        Vector2(500, 300),
        Vector2(1920, 1080)
      ];

      for (final screenSize in testCases) {
        final uploadButton = UploadButton(
          uploadGame: () {},
          screenSize: screenSize,
        );

        // Simulate component loading
        uploadButton.onLoad();

        // Verify positioning relative to screen size
        expect(uploadButton.x, equals(screenSize.x - 50));
        expect(uploadButton.y, equals(50));
      }
    });
  });
}