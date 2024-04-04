import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/data/api/api_service.dart';
import 'package:resto_app/provider/restaurant_list_provider.dart';
import 'package:resto_app/ui/restaurant_detail.page.dart';
import 'package:resto_app/ui/restaurant_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const routeName = '/home_page';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        MyApp.routeName: (context) =>
            ChangeNotifierProvider<RestaurantListProvider>(
              create: (context) =>
                  RestaurantListProvider(apiService: ApiService()),
              child: const RestaurantListPage(),
            ),
        RestaurantDetailPage.routeName: (context) {
          final id = ModalRoute.of(context)?.settings.arguments as String;
          return RestaurantDetailPage(id: id);
        }
      },

      // home:
      // ChangeNotifierProvider<RestaurantListProvider>(
      //   create: (context) => RestaurantListProvider(apiService: ApiService()),
      //   child: const RestaurantListPage(),
      // )
    );
  }
}
