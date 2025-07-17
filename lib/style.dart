import 'package:flutter/material.dart';

class AppColours {
  /*  Background  */
  static const Color background = Color.fromRGBO(214, 195, 228, 1);

  /*  Different Colour-Patterns */
  static const Color label = Color.fromRGBO(61, 38, 69, 1);
  static const Color primary = Color.fromRGBO(97, 19, 95, 1);
  static const Color primaryDark = Color.fromRGBO(64, 30, 120, 1);

  /*  Text-Colour */
  static const Color lightText = Color.fromRGBO(244, 239, 250, 1);

  /*  Button-States includes Symbols  */
  static const Color buttonUnpressed = Color.fromRGBO(244, 239, 250, 1);
  static const Color buttonPressed = Color.fromRGBO(151, 58, 168, 1);
}

class AppTextStyles {
  /*  Writing Styles  */
  static const TextStyle header = TextStyle(
    color: AppColours.lightText,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  static const TextStyle italicHeader = TextStyle(
    color: AppColours.lightText,
    fontSize: 18,
    fontStyle: FontStyle.italic,
  );
}
