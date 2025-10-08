import 'package:flutter/material.dart';

ThemeData getCalculatorTheme(Brightness brightness) {
  final bool isDark = brightness == Brightness.dark;

  final backgroundGradient = isDark
      ? const RadialGradient(
          center: Alignment(-0.6, -0.8),
          radius: 1.5,
          colors: [
            Color.fromARGB(255, 4, 11, 26),
            Color.fromARGB(255, 10, 30, 64),
            Color.fromARGB(255, 26, 53, 112),
            Color.fromARGB(255, 46, 47, 127),
            Color.fromARGB(255, 91, 43, 155),
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        )
      : const RadialGradient(
          center: Alignment(-0.6, -0.8),
          radius: 1.5,
          colors: [
            Color.fromARGB(255, 227, 175, 255),
            Color.fromARGB(255, 248, 174, 221),
            Color.fromARGB(255, 231, 121, 241),
            Color.fromARGB(255, 211, 135, 246),
            Color.fromARGB(255, 177, 151, 248),
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        );

  final accentColor = isDark
      ? const Color.fromARGB(255, 10, 30, 64)
      : const Color.fromARGB(255, 230, 107, 241);

  return ThemeData(
    brightness: brightness,
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.zero,
        elevation: 2,
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    ),

    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 32,
    ),

    extensions: [
      CalculatorGradients(
        background: backgroundGradient,
      ),
    ],
  );
}

class CalculatorGradients extends ThemeExtension<CalculatorGradients> {
  final Gradient background;

  const CalculatorGradients({
    required this.background,
  });

  @override
  CalculatorGradients copyWith({Gradient? background}) {
    return CalculatorGradients(
      background: background ?? this.background,
    );
  }

  @override
  CalculatorGradients lerp(ThemeExtension<CalculatorGradients>? other, double t) {
    if (other is! CalculatorGradients) {
      return this;
    }
    return this;
  }
}