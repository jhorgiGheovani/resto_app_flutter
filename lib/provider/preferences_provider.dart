import 'package:flutter/widgets.dart';
import 'package:resto_app/data/localdb/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getNotif();
  }

  void _getNotif() async {
    _isDarkTheme = await preferencesHelper.isNotifOn;
    notifyListeners();
  }

  void enableNotification(bool value) {
    preferencesHelper.setNotif(value);
    _getNotif();
  }
}
