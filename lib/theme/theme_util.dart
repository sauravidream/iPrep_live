import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idream/theme/color_constants.dart';

class ThemeUtil {
  static final ThemeData themeData = ThemeData.light().copyWith(
    dividerColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.grey,
      ),
    ),
    textTheme: TextTheme(
        bodyText1: TextStyle(
          fontFamily: GoogleFonts.inter().fontFamily,
          color: Colors.red,
          fontSize: 15,
          fontWeight: FontWeight.values[5],
        ),
        bodyText2: GoogleFonts.inter(),
        headline1: GoogleFonts.inter(),
        headline2: GoogleFonts.inter(),
        headline3: GoogleFonts.inter(),
        headline4: GoogleFonts.inter(),
        headline5: GoogleFonts.inter(),
        headline6: GoogleFonts.inter(),
        subtitle1: GoogleFonts.inter(),
        subtitle2: GoogleFonts.inter(),
        overline: const TextStyle()),
    primaryColor: kPrimaryColour,
    primaryColorDark: kPrimaryDarkColour,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: kAccentColor,
    ),
  );
}
