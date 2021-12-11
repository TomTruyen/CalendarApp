import 'package:calendar_app/screens/calendar_screen.dart';
import 'package:calendar_app/services/theme_service.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService _themeService = ThemeService();
  bool _isDarkMode = false;

  _MyAppState() {
    init();
  }

  void init() async {
    bool isDarkMode = await _themeService.isDarkTheme();

    setTheme(isDarkMode);
  }

  void setTheme(bool isDarkMode) {
    _themeService.setTheme(isDarkMode);

    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar App',
      theme: Themes.light.copyWith(
        colorScheme: Themes.light.colorScheme.copyWith(
          secondary: Themes.lightPrimary,
        ),
      ),
      darkTheme: Themes.dark.copyWith(
        colorScheme: Themes.dark.colorScheme.copyWith(
          secondary: Themes.darkPrimary,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor:
                _isDarkMode ? Themes.darkStatus : Themes.lightStatus,
          ),
          actions: <Widget>[
            IconButton(
              icon: _isDarkMode
                  ? const Icon(
                      Icons.light_mode_outlined,
                      color: Colors.white,
                      size: 20,
                    )
                  : const Icon(
                      Icons.dark_mode_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
              onPressed: () {
                setTheme(!_isDarkMode);
              },
            )
          ],
        ),
        body: const CalendarScreen(),
      ),
    );
  }
}
