import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Styles {
  static ThemeData themeData(bool isDarkMode, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
          isDarkMode ? const Color(0xFF262626) : Colors.white,
      primaryColor: isDarkMode ? Colors.white : Colors.black,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          )),
      iconTheme: IconThemeData(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkMode ? const Color(0xFF262626) : Colors.white,
        selectedItemColor: isDarkMode ? Colors.white : Colors.black,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme.apply(
              bodyColor: isDarkMode ? Colors.white : Colors.black,
              displayColor: isDarkMode ? Colors.white : Colors.black,
            ),
      ),
    );
  }
}

class ThemePrefs {
  // ignore: constant_identifier_names
  static const String THEME_TYPE = 'THEMETYPE';

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_TYPE, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_TYPE) ?? false;
  }
}

class ThemeProvider with ChangeNotifier {
  ThemePrefs themePrefs = ThemePrefs();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    themePrefs.setDarkTheme(value);
    notifyListeners();
  }
}
