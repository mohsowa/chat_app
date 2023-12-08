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
Color get white => const Color.fromRGBO(255, 255, 255, 1.0);

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

BoxShadow boxShadow = BoxShadow(
  color: themeDarkBlue.withOpacity(0.05),
  spreadRadius: 1,
  blurRadius: 20,
  offset: const Offset(0, 1),
  blurStyle: BlurStyle.outer,
);
