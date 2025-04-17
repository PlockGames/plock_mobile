import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:plock_mobile/pages/play/exitbutton.dart'; // Ajustez l'import selon votre structure de projet

void main() {
  group('ExitButton tests', () {
    late ExitButton exitButton;
    late Function exitGameMock;

    setUp(() {
      // Crée un mock de la fonction exitGame
      exitGameMock = () {};

      // Crée un ExitButton avec le mock de la fonction
      exitButton = ExitButton(exitGame: exitGameMock);
    });

    test('ExitButton should have correct text', () {
      // Charge le composant pour que le texte soit initialisé
      exitButton.onLoad();

      // Vérifie que le texte du bouton est bien 'Exit'
      expect(exitButton.text, 'Exit');
    });



    test('ExitButton should have the correct position and style', () {
      // Charge le composant pour initialiser sa position et son style
      exitButton.onLoad();

      // Vérifie la position du bouton
      expect(exitButton.x, 20);
      expect(exitButton.y, 50);

      // Vérifie les propriétés de style du texte
      final TextPaint textPaint = exitButton.textRenderer as TextPaint; // Assurez-vous que textRenderer est de type TextPaint
      final TextStyle textStyle = textPaint.style;

      expect(textStyle.fontSize, 20.0);
      expect(textStyle.color, BasicPalette.white.color);
    });
  });
}
