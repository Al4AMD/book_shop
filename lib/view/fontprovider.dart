import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  String _selectedFont = 'Roboto';

  String get selectedFont => _selectedFont;

  FontProvider() {
    _loadFont();
  }

  Future<void> _loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString('selectedFont') ?? 'Roboto';
    notifyListeners();
  }

  Future<void> setFont(String fontName) async {
    _selectedFont = fontName;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', fontName);
  }
}
