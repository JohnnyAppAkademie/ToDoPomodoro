import 'package:flutter/material.dart';
import 'package:todopomodoro/src/core/theme/themes.dart';

extension ScreenSizeExtension on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  double get hgap1 => screenHeight * 0.01;
  double get hgap2 => screenHeight * 0.02;
  double get hgap5 => screenHeight * 0.05;
  double get hgap10 => screenHeight * 0.10;

  double get wgap1 => screenWidth * 0.01;
  double get wgap2 => screenWidth * 0.02;
  double get wgap5 => screenWidth * 0.05;
  double get wgap10 => screenWidth * 0.10;

  AppButtonStyles get buttonStyles =>
      Theme.of(this).extension<AppButtonStyles>()!;

  TextThemeStyles get textStyles =>
      Theme.of(this).extension<TextThemeStyles>()!;

  AppStyle get appStyle => Theme.of(this).extension<AppStyle>()!;

  AppBarTheme get appBarTheme => Theme.of(this).appBarTheme;
}
