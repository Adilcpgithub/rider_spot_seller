import 'package:shared_preferences/shared_preferences.dart';

class AdminStatus {
  static const String userId = 'riderspot401#@@';
  static Future<void> setAdminLogin(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdminLoggedIn', isLoggedIn);
  }

  static Future<bool> isAdminLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdminLoggedIn') ?? false;
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
