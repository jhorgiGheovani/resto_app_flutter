import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resto_app/common/style.dart';
import 'package:resto_app/provider/preferences_provider.dart';
import 'package:resto_app/provider/scheduling_provider.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings_page';

  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Settings',
          style: myTextTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              fontFamily: GoogleFonts.rubik().fontFamily),
        ),
        titleSpacing: 0,
        scrolledUnderElevation: 0.0,
      ),
      body: Material(
          child: Center(
        child: Column(
          children: [
            ListTile(
              title: const Text("Notification Restaurant"),
              subtitle: Text(
                "Notifikasi restaurant akan muncul setiap hari pukul 11.00",
                style: myTextTheme.labelSmall?.copyWith(color: Colors.blueGrey),
              ),
              trailing: Consumer2<SchedulingProvider, PreferencesProvider>(
                builder:
                    (context, schedulingProvider, preferenceProvider, child) {
                  return Switch.adaptive(
                    value: preferenceProvider.isDarkTheme,
                    onChanged: (value) async {
                      preferenceProvider.enableNotification(value);
                      schedulingProvider.scheduledNews(value);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
