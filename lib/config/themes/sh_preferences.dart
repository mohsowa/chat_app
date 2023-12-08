import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const String themeKey = "isDarkMode";

  Future<void> setDarkMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeKey, value);
  }

  Future<bool> isDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false; // Default to false if not set
  }
}
