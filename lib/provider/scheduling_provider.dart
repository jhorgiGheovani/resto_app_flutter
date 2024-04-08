import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:resto_app/utils/background_service.dart';
import 'package:flutter/material.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduledNews(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling News Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        1,
        BackgroundService.callback,
        exact: true,
        allowWhileIdle: true,
        rescheduleOnReboot: true,
        wakeup: true,
        startAt: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, 11),
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
