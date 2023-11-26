import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get _textStyle => GoogleFonts.getFont(
      'Cairo',
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );

// colors
Color get themeBlue => const Color.fromRGBO(64, 194, 210, 1);
Color get themeDarkBlue => const Color.fromRGBO(10, 44, 64, 1);
Color get themePink => const Color.fromRGBO(213, 20, 122, 1);
Color get themeRed => const Color.fromRGBO(165, 30, 34, 1);
Color get themeLightGrey => const Color.fromRGBO(211, 211, 211, 1.0);

