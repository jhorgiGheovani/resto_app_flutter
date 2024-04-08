import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
  static const settingKeys = 'SEETING_KEY';

  PreferencesHelper({required this.sharedPreferences});

  Future<bool> get isNotifOn async {
    final prefs = await sharedPreferences;
    return prefs.getBool(settingKeys) ?? false;
  }

  void setNotif(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(settingKeys, value);
  }
}
