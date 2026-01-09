import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,

      // 👇 APPLY INTER HERE
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,

      // 👇 APPLY INTER HERE
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }
}
