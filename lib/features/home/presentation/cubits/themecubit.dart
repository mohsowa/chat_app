import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool('isDarkTheme');
    if (savedTheme != null) {
      emit(savedTheme); // Emit the saved theme mode
    }
  }


  void toggleTheme(BuildContext context) async {
    final newThemeState = !state;
    emit(newThemeState);

    // Save the theme preference
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', newThemeState);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(), // Replace with your home page widget
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
