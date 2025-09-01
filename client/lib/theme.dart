import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///
/// Light theme
///
final ThemeData lightTheme = ThemeData.light().copyWith();

///
/// Dark theme
///
final ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: GoogleFonts.ubuntuTextTheme(ThemeData.dark().textTheme),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    surfaceTintColor: Colors.transparent,
    foregroundColor: Colors.white,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);
