import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: white,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        color: themeDarkBlue,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.cairo(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: themeBlue),
        ),
        bodyMedium: GoogleFonts.cairo(
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: themeGrey),
        ),
        titleLarge: GoogleFonts.cairo(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeBlue),
        ),
        // Define other text styles for different use cases as needed
      ),
      // Define other theme properties as needed
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: themeGreyDark,
      backgroundColor: themeGreyDark,
      scaffoldBackgroundColor: themeGreyDark,
      appBarTheme: AppBarTheme(
        color: white,
        iconTheme: IconThemeData(color: Colors.white), // Ensure icons are also light-colored
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.cairo(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: themeBlue),
        ),
        bodyMedium: GoogleFonts.cairo(
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: white),
        ),
        titleLarge: GoogleFonts.cairo(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeBlue),
        ),

        // Define other text styles for different use cases as needed
      ),
      // Define other theme properties as needed
    );
  }

}

// Define your colors and styles here
Color get themeBlue => const Color.fromRGBO(64, 194, 210, 1);
Color get themeDarkBlue => const Color.fromRGBO(10, 44, 64, 1);
Color get themePink => const Color.fromRGBO(213, 20, 122, 1);
Color get themeRed => const Color.fromRGBO(165, 30, 34, 1);
Color get themeLightGrey => const Color.fromRGBO(211, 211, 211, 1.0);
Color get white => const Color.fromRGBO(255, 255, 255, 1.0);
Color get themeBlack => const Color.fromRGBO(0, 0, 30, 30);
// gray dark
Color get themeGreyDark => const Color.fromRGBO(22, 38, 51, 0.5019607843137255);
// Define other styles as needed
BoxShadow boxShadow = BoxShadow(
  color: themeDarkBlue.withOpacity(0.05),
  spreadRadius: 1,
  blurRadius: 20,
  offset: const Offset(0, 1),
  blurStyle: BlurStyle.outer,
);

const Color inputFieldColor = Colors.white;
Color themeGrey = themeDarkBlue.withOpacity(0.5);


BoxDecoration primaryDecoration = BoxDecoration(
    color: white,
    border: Border.fromBorderSide(
      BorderSide(
        color: themeDarkBlue.withOpacity(0.2),
        width: 0.5,
      ),
    ),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    boxShadow: [boxShadow]);
