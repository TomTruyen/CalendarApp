import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  SharedPreferences? _prefs;

  ThemeService() {
    init();
  }

  void init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> isDarkTheme() async {
    return Future.value(_prefs?.getBool("isDarkMode") ?? false);
  }

  void setTheme(bool isDarkMode) async {
    await _prefs?.setBool("isDarkMode", isDarkMode);
  }
}
