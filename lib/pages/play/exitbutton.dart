import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';

/// A button to exit the game in test mode.
class ExitButton extends TextComponent with TapCallbacks {

  /// Callback to exit the game.
  final Function exitGame;

  ExitButton({required this.exitGame});

  @override
  void onLoad() {
    super.onLoad();
    text = 'Exit';
    anchor = Anchor.topLeft;
    x = 20;
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
    exitGame();
    return true;
  }
}