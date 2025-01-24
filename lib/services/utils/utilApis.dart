import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class UtilsService {
  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    log("id: ${prefs.getInt('id')}");
    return prefs.getInt('id') ?? 0;
  }

  static Future<void> storeUserInfo(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', data['id']);
  }
}
