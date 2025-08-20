import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorSchemeSeed: const Color(0xFF2E2B62),
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: GoogleFonts.poppinsTextTheme(),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
  );
}
