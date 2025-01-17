import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  // Add primaryColor property
  Color get primaryColor {
    return _isDark
        ? Color(0xFF1E90FF)
        : Color(0xFF007BFF); // Bright blue for both modes
  }

  // Add secondaryColor property
  Color get secondaryColor {
    return _isDark
        ? Color(0xFF121212)
        : Color(0xFFF0F0F0); // Dark for dark mode and soft white for light mode
  }

  // Add addbutton color property
  Color get addbutton {
    return _isDark
        ? Color(0xFFFF6347)
        : Color(
            0xFF4CAF50); // Tomato color for dark mode and green for light mode
  }

  ThemeProvider() {
    _loadFromPrefs();
  }

  void changeTheme() {
    _isDark = !_isDark;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _isDark);
  }
}
