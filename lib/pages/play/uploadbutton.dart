import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';

/// A button to exit the game in test mode.
class UploadButton extends TextComponent with TapCallbacks {

  /// Callback to exit the game.
  final Function uploadGame;

  /// The screen size
  final Vector2 screenSize;

  UploadButton({required this.uploadGame, required this.screenSize});

  @override
  void onLoad() {
    super.onLoad();
    text = 'Upload';
    anchor = Anchor.topRight;
    x = screenSize.x - 50;
    y = 50;
    textRenderer = TextPaint(
      style: TextStyle(
        color: BasicPalette.white.color,
        fontSize: 20.0,
      ),
    );
  }

  @override
  bool onTapUp(_) {
    uploadGame();
    return true;
  }
}