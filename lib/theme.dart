import 'package:flutter/material.dart';

class PlockTheme {
  // --- Nouvelle Palette ---
  // Couleurs Primaires
  static const Color primaryBlue = Color(0xFF074888); // Bleu
  static const Color primaryOrange = Color(0xFFFA6317); // Orange Foncé

  // Couleurs Secondaires
  static const Color secondaryBlue = Color(0xFF47F8FF); // Bleu Clair
  static const Color secondaryOrange = Color(0xFFFFA13A); // Orange
  static const Color secondaryLightOrange = Color(0xFFFFFDE2); // Orange Clair

  // Couleurs Neutres (Adaptées pour un thème sombre)
  static const Color backgroundDark =
      Color(0xFF121212); // Fond principal sombre
  static const Color backgroundLight =
      Color(0xFF1E1E1E); // Fond légèrement plus clair
  static const Color cardColor =
      Color(0xFF2A2A2A); // Couleur des cartes/surfaces
  static const Color dividerColor = Color(0xFF3A3A3A); // Séparateurs

  // Couleurs de Texte
  static const Color textPrimary = Color(0xFFFFFFFF); // Texte principal (blanc)
  static const Color textSecondary =
      Color(0xFFBBBBBB); // Texte secondaire (gris clair)
  static const Color textMuted =
      Color(0xFF888888); // Texte atténué (gris moyen)
  static const Color textOnPrimaryBlue =
      Color(0xFFFFFFFF); // Texte sur fond bleu primaire
  static const Color textOnPrimaryOrange =
      Color(0xFFFFFFFF); // Texte sur fond orange primaire
  static const Color textOnError = Color(0xFFFFFFFF); // Texte sur fond d'erreur

  // Couleur d'Erreur (Standard)
  static const Color errorColor = Color(0xFFEF4444); // Rouge pour les erreurs

  // Couleur de Succès
  static const Color successColor = Color(0xFF22C55E); // Vert pour les succès

  // --- Polices ---
  static const String fontHelveticaNeue =
      'Helvetica Neue'; // Police principale (Titres)
  static const String fontMontserrat =
      'Montserrat'; // Police secondaire (Corps)

  // Create our dark theme
  static ThemeData darkTheme() {
    // Définir le TextTheme de base avec Montserrat
    final textThemeBase = ThemeData.dark().textTheme.apply(
          fontFamily: fontMontserrat,
          bodyColor: textSecondary, // Couleur par défaut pour le corps
          displayColor:
              textPrimary, // Couleur par défaut pour les titres/affichages
        );

    // Appliquer Helvetica Neue aux styles de titres/importants
    final textTheme = textThemeBase.copyWith(
      headlineLarge: textThemeBase.headlineLarge?.copyWith(
          fontFamily: fontHelveticaNeue,
          color: textPrimary,
          fontWeight: FontWeight.bold),
      headlineMedium: textThemeBase.headlineMedium?.copyWith(
          fontFamily: fontHelveticaNeue,
          color: textPrimary,
          fontWeight: FontWeight.bold),
      headlineSmall: textThemeBase.headlineSmall?.copyWith(
          fontFamily: fontHelveticaNeue,
          color: textPrimary,
          fontWeight: FontWeight.bold),
      titleLarge: textThemeBase.titleLarge?.copyWith(
          fontFamily: fontHelveticaNeue,
          color: textPrimary,
          fontWeight: FontWeight.w600),
      titleMedium: textThemeBase.titleMedium?.copyWith(
          fontFamily: fontHelveticaNeue,
          color: textPrimary,
          fontWeight: FontWeight.w600),
      titleSmall: textThemeBase.titleSmall?.copyWith(
          fontFamily: fontHelveticaNeue,
          color: textPrimary,
          fontWeight: FontWeight.w600),
      // Styles pour le corps du texte (utilisent Montserrat par défaut via apply)
      bodyLarge: textThemeBase.bodyLarge?.copyWith(color: textPrimary),
      bodyMedium: textThemeBase.bodyMedium?.copyWith(color: textSecondary),
      bodySmall: textThemeBase.bodySmall?.copyWith(color: textMuted),
      // Styles pour les boutons, etc.
      labelLarge: textThemeBase.labelLarge?.copyWith(
          fontFamily: fontHelveticaNeue,
          color: textPrimary,
          fontWeight: FontWeight.bold), // Utilisé par ElevatedButton
    );

    return ThemeData.dark().copyWith(
      primaryColor:
          primaryBlue, // Utiliser le bleu comme couleur primaire principale
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardColor,
      dividerColor: dividerColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue, // Bleu primaire
        secondary:
            primaryOrange, // Orange foncé comme secondaire (peut être ajusté)
        tertiary: secondaryBlue, // Bleu clair comme tertiaire
        error: errorColor,
        background: backgroundDark,
        surface: cardColor,
        onPrimary: textOnPrimaryBlue, // Texte sur fond bleu
        onSecondary: textOnPrimaryOrange, // Texte sur fond orange
        onTertiary:
            textPrimary, // Texte sur fond bleu clair (à ajuster si nécessaire)
        onBackground: textPrimary,
        onSurface: textPrimary,
        onError: textOnError,
      ),
      textTheme: textTheme, // Appliquer le TextTheme personnalisé
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        titleTextStyle:
            textTheme.titleLarge, // Utiliser le style de titre du thème
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundLight,
        selectedItemColor:
            primaryBlue, // Utiliser le bleu primaire pour l'élément sélectionné
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: primaryBlue, width: 2), // Utiliser le bleu primaire
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: TextStyle(
            color: textMuted,
            fontFamily: fontMontserrat), // Police pour le hint
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: textOnPrimaryBlue, // Texte sur le bouton
          backgroundColor: primaryBlue, // Fond bleu primaire
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(
              fontFamily: fontHelveticaNeue), // Police pour le bouton
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue, // Texte bleu primaire
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          textStyle: textTheme.labelLarge?.copyWith(
              fontFamily: fontHelveticaNeue), // Police pour le bouton
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue, // Texte bleu primaire
          side: const BorderSide(color: primaryBlue), // Bordure bleue primaire
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
              fontFamily: fontHelveticaNeue), // Police pour le bouton
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: cardColor,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle:
            textTheme.titleLarge, // Utiliser le style de titre du thème
        contentTextStyle:
            textTheme.bodyMedium, // Utiliser le style de corps du thème
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cardColor,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
            color: textPrimary), // Utiliser le style de corps du thème
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: backgroundLight.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
            color: textPrimary), // Utiliser le style de corps du thème
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryBlue, // Utiliser le bleu primaire
        unselectedLabelColor: textMuted,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
              color: primaryBlue, width: 2), // Utiliser le bleu primaire
        ),
        labelStyle: textTheme.titleSmall?.copyWith(
            fontFamily: fontHelveticaNeue), // Police pour les onglets
        unselectedLabelStyle: textTheme.titleSmall?.copyWith(
            fontFamily: fontHelveticaNeue), // Police pour les onglets
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryBlue, // Utiliser le bleu primaire
        inactiveTrackColor: primaryBlue.withOpacity(0.3),
        thumbColor: primaryBlue, // Utiliser le bleu primaire
        overlayColor: primaryBlue.withOpacity(0.2),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue; // Utiliser le bleu primaire
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(textOnPrimaryBlue),
        side: const BorderSide(color: textMuted),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue; // Utiliser le bleu primaire
          }
          return textMuted;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue; // Utiliser le bleu primaire
          }
          return textMuted;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue.withOpacity(0.5); // Utiliser le bleu primaire
          }
          return textMuted.withOpacity(0.5);
        }),
      ),
    );
  }
}
