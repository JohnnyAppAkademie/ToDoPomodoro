import 'package:flutter/material.dart';

class AppStyle extends ThemeExtension<AppStyle> {
  final Color background;
  final Color labelBackground;
  final Color gradient1;
  final Color gradient2;
  final Color gradient3;
  final Color buttonBackgroundprimary;
  final Color buttonBackgroundLight;
  final Color columnBackground;
  final Color writingLight;
  final Color writingDark;
  final Color writingHighlight;
  final Color notActive;

  const AppStyle({
    required this.background,
    required this.labelBackground,
    required this.gradient1,
    required this.gradient2,
    required this.gradient3,
    required this.buttonBackgroundprimary,
    required this.buttonBackgroundLight,
    required this.columnBackground,
    required this.writingLight,
    required this.writingDark,
    required this.writingHighlight,
    required this.notActive,
  });

  factory AppStyle.standard() {
    return const AppStyle(
      background: Color(0xFFD6C3E4),
      labelBackground: Color(0xFF401E78),
      gradient1: Color(0XFF401E78),
      gradient2: Color(0XFF973AA8),
      gradient3: Color(0XFF401E78),
      buttonBackgroundprimary: Color(0XFF973AA8),
      buttonBackgroundLight: Color(0XFFF4F3FA),
      columnBackground: Color(0xFF401E78),
      writingLight: Color(0XFFF4F3FA),
      writingDark: Color(0xFF401E78),
      writingHighlight: Color(0xFF973AA8),
      notActive: Color(0xFFBFB2C2),
    );
  }

  @override
  AppStyle copyWith({
    Color? background,
    Color? labelBackground,
    Color? gradient1,
    Color? gradient2,
    Color? gradient3,
    Color? buttonBackgroundprimary,
    Color? buttonBackgroundLight,
    Color? columnBackground,
    Color? writingLight,
    Color? writingDark,
    Color? writingHighlight,
    Color? notActive,
  }) {
    return AppStyle(
      background: background ?? this.background,
      labelBackground: labelBackground ?? this.labelBackground,
      gradient1: gradient1 ?? this.gradient1,
      gradient2: gradient2 ?? this.gradient2,
      gradient3: gradient3 ?? this.gradient3,
      buttonBackgroundprimary:
          buttonBackgroundprimary ?? this.buttonBackgroundprimary,
      buttonBackgroundLight:
          buttonBackgroundLight ?? this.buttonBackgroundLight,
      columnBackground: columnBackground ?? this.columnBackground,
      writingLight: writingLight ?? this.writingLight,
      writingDark: writingDark ?? this.writingDark,
      writingHighlight: writingHighlight ?? this.writingHighlight,
      notActive: notActive ?? this.notActive,
    );
  }

  @override
  AppStyle lerp(ThemeExtension<AppStyle>? other, double t) {
    if (other is! AppStyle) return this;
    return AppStyle(
      background: Color.lerp(background, other.background, t)!,
      labelBackground: Color.lerp(labelBackground, other.labelBackground, t)!,
      gradient1: Color.lerp(gradient1, other.gradient1, t)!,
      gradient2: Color.lerp(gradient2, other.gradient2, t)!,
      gradient3: Color.lerp(gradient3, other.gradient3, t)!,
      buttonBackgroundprimary: Color.lerp(
        buttonBackgroundprimary,
        other.buttonBackgroundprimary,
        t,
      )!,
      buttonBackgroundLight: Color.lerp(
        buttonBackgroundLight,
        other.buttonBackgroundLight,
        t,
      )!,
      columnBackground: Color.lerp(
        columnBackground,
        other.columnBackground,
        t,
      )!,
      writingLight: Color.lerp(writingLight, other.writingLight, t)!,
      writingDark: Color.lerp(writingDark, other.writingDark, t)!,
      writingHighlight: Color.lerp(
        writingHighlight,
        other.writingHighlight,
        t,
      )!,
      notActive: Color.lerp(notActive, other.notActive, t)!,
    );
  }
}

class AppButtonStyles extends ThemeExtension<AppButtonStyles> {
  final ButtonStyle primary;
  final ButtonStyle secondary;
  final ButtonStyle card;

  const AppButtonStyles({
    required this.primary,
    required this.secondary,
    required this.card,
  });

  @override
  AppButtonStyles copyWith({
    ButtonStyle? primary,
    ButtonStyle? secondary,
    ButtonStyle? card,
  }) {
    return AppButtonStyles(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      card: card ?? this.card,
    );
  }

  @override
  AppButtonStyles lerp(ThemeExtension<AppButtonStyles>? other, double t) {
    return this;
  }
}

class TextThemeStyles extends ThemeExtension<TextThemeStyles> {
  final TextTheme light;
  final TextTheme dark;
  final TextTheme highlight;

  const TextThemeStyles({
    required this.light,
    required this.dark,
    required this.highlight,
  });

  @override
  TextThemeStyles copyWith({
    TextTheme? light,
    TextTheme? dark,
    TextTheme? highlight,
  }) {
    return TextThemeStyles(
      light: light ?? this.light,
      dark: dark ?? this.dark,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  TextThemeStyles lerp(ThemeExtension<TextThemeStyles>? other, double t) {
    if (other is! TextThemeStyles) return this;
    return TextThemeStyles(
      light: TextTheme.lerp(light, other.light, t),
      dark: TextTheme.lerp(dark, other.dark, t),
      highlight: TextTheme.lerp(highlight, other.highlight, t),
    );
  }
}

ThemeData standardTheme(AppStyle style) {
  final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: style.buttonBackgroundprimary,
    foregroundColor: style.writingLight,
  );

  final ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: style.buttonBackgroundLight,
    foregroundColor: style.writingDark,
  );

  final ButtonStyle cardButton = ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    minimumSize: const Size(0, 35),
    backgroundColor: style.buttonBackgroundLight,
    foregroundColor: style.buttonBackgroundprimary,
  );

  final TextTheme darkStyle = TextTheme(
    /*  Titel */
    titleLarge: TextStyle(
      color: style.writingDark,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),

    titleMedium: TextStyle(color: style.writingDark, fontSize: 48),

    titleSmall: TextStyle(
      color: style.writingDark,
      fontSize: 46,
      fontStyle: FontStyle.italic,
    ),

    /*  Label */
    labelLarge: TextStyle(
      color: style.writingDark,
      fontSize: 46,
      fontWeight: FontWeight.bold,
    ),

    labelMedium: TextStyle(color: style.writingDark, fontSize: 20),

    labelSmall: TextStyle(
      color: style.writingDark,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    ),

    /* Body */
    bodyLarge: TextStyle(
      color: style.writingDark,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),

    bodyMedium: TextStyle(color: style.writingDark, fontSize: 16),

    bodySmall: TextStyle(
      color: style.writingDark,
      fontSize: 14,
      fontStyle: FontStyle.italic,
    ),
  );

  final TextTheme lightStyle = TextTheme(
    /*  Titel */
    titleLarge: TextStyle(
      color: style.writingLight,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),

    titleMedium: TextStyle(color: style.writingLight, fontSize: 48),

    titleSmall: TextStyle(
      color: style.writingLight,
      fontSize: 46,
      fontStyle: FontStyle.italic,
    ),

    /*  Label */
    labelLarge: TextStyle(
      color: style.writingLight,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(color: style.writingLight, fontSize: 20),

    labelSmall: TextStyle(
      color: style.writingLight,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    ),

    /* Body */
    bodyLarge: TextStyle(
      color: style.writingLight,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: style.writingLight, fontSize: 16),

    bodySmall: TextStyle(
      color: style.writingLight,
      fontSize: 14,
      fontStyle: FontStyle.italic,
    ),
  );

  final TextTheme highlightStyle = TextTheme(
    /*  Titel */
    titleLarge: TextStyle(
      color: style.writingHighlight,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),

    titleMedium: TextStyle(color: style.writingHighlight, fontSize: 48),

    titleSmall: TextStyle(
      color: style.writingHighlight,
      fontSize: 46,
      fontStyle: FontStyle.italic,
    ),

    /*  Label */
    labelLarge: TextStyle(
      color: style.writingHighlight,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(color: style.writingHighlight, fontSize: 20),

    labelSmall: TextStyle(
      color: style.writingHighlight,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    ),

    /* Body */
    bodyLarge: TextStyle(
      color: style.writingHighlight,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: style.writingHighlight, fontSize: 16),

    bodySmall: TextStyle(
      color: style.writingHighlight,
      fontSize: 14,
      fontStyle: FontStyle.italic,
    ),
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: style.background,

    /*  Appbar - Theme */
    appBarTheme: AppBarTheme(
      backgroundColor: style.labelBackground,
      foregroundColor: style.writingLight,
    ),

    /*  Navigationbar - Theme */
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: style.labelBackground,
      indicatorColor: style.buttonBackgroundprimary,
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: style.buttonBackgroundLight);
        }
        return IconThemeData(color: style.notActive);
      }),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: style.writingLight,
      contentTextStyle: highlightStyle.labelSmall,
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),

    /* Extension  */
    extensions: [
      AppButtonStyles(
        primary: primaryButton,
        secondary: secondaryButton,
        card: cardButton,
      ),
      TextThemeStyles(
        light: lightStyle,
        dark: darkStyle,
        highlight: highlightStyle,
      ),
      AppStyle.standard(),
    ],
  );
}
