import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/data/localdb/preferences_helper.dart';
import 'package:resto_app/data/localdb/sqlite_database_helper.dart';
import 'package:resto_app/provider/database_provider.dart';
import 'package:resto_app/provider/preferences_provider.dart';
import 'package:resto_app/provider/restaurant_list_provider.dart';
import 'package:resto_app/provider/scheduling_provider.dart';
import 'package:resto_app/ui/favorite_resto_page.dart';
import 'package:resto_app/ui/restaurant_detail_page.dart';
import 'package:resto_app/ui/restaurant_list_page.dart';
import 'package:resto_app/ui/settings_page.dart';
import 'package:resto_app/utils/background_service.dart';
import 'package:resto_app/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const routeName = '/home_page';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantListProvider>(
            create: (_) => RestaurantListProvider(apiService: ApiService())
              ..fetchRestaurantList(),
          ),
          ChangeNotifierProvider(
              create: (_) => DatabaseProvider(
                  sqLiteDatabaseHelper: SqLiteDatabaseHelper())),
          ChangeNotifierProvider(create: (_) => SchedulingProvider()),
          ChangeNotifierProvider(
            create: (_) => PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance(),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'RestoApp Bro',
          theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: primaryColor,
                  onPrimary: Colors.black,
                  secondary: secondaryColor,
                ),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: myTextTheme,
            appBarTheme: const AppBarTheme(elevation: 0),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: secondaryColor,
              unselectedItemColor: Colors.grey,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                textStyle: const TextStyle(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          initialRoute: MyApp.routeName,
          routes: {
            MyApp.routeName: (context) => const RestaurantListPage(),
            RestaurantDetailPage.routeName: (context) {
              final id = ModalRoute.of(context)?.settings.arguments as String;
              return RestaurantDetailPage(id: id);
            },
            FavoriteRestoPage.routeName: (context) => const FavoriteRestoPage(),
            SettingsPage.routeName: (context) => const SettingsPage()
          },
        ));
  }
}
