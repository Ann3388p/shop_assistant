import 'package:flutter/material.dart';

class ColorTheme {
  static const Color primaryColor = Color(0xFF89C74A);
  static const Color primaryTextColor = Color(0xFF061303);
  static const Color lightTextColor = Colors.white;
  static Color greyColor = Color(0xFFC4C4C4).withOpacity(0.2);
  static const Color yellowColor = Color(0xFFFFD951);
  static const Color backgroundBluishWhite = Color(0xFFF7FAFF);
  static const Color backgroundGreenishWhite = Color(0xFFEAF6E1);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightBlueBackground = Color(0xFFEAEEF7);
  static const Color primaryBlue = Color(0xFF2D93FB);
  static const Color errorRed = Color(0xFFEA4335);
  static Color disabledGreen = Color(0xFF85BE49).withOpacity(0.2);
  static Color disabledGreenText = Colors.black.withOpacity(0.4);

  static const Gradient yellowGradient =
  LinearGradient(colors: [Color(0xFFFFDB51), Color(0xFFFFC800)]);
  static const Gradient yellowGradient3 = LinearGradient(
    colors: [Color(0xFFFFDB51), Color(0xFFFFC800)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Gradient yellowGradient2 = LinearGradient(
      colors: [Color(0xFFFFD951), Color(0xFFFFC800), Color(0xFFFFC800)]);
  static const Gradient greenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.9],
    colors: [
      Color(0xFF85BE49),
      Color(0xFF69A85C),
    ],
  );
}
