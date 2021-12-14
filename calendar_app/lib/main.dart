import 'package:calendar_app/screens/calendar_screen.dart';
import 'package:calendar_app/services/globals.dart';
import 'package:calendar_app/services/theme_service.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Globals _globals = Globals();
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    _globals.isDarkMode = await _themeService.isDarkTheme();
    refresh();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar App',
      theme: Themes.light.copyWith(
        colorScheme: Themes.light.colorScheme.copyWith(
          secondary: Themes.light.primaryColor,
        ),
      ),
      darkTheme: Themes.dark.copyWith(
        colorScheme: Themes.dark.colorScheme.copyWith(
          secondary: Themes.dark.primaryColor,
        ),
      ),
      themeMode: _globals.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            IconButton(
              splashRadius: 16,
              icon: _globals.isDarkMode
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
                _globals.isDarkMode = !_globals.isDarkMode;
                refresh();
              },
            )
          ],
        ),
        body: const CalendarScreen(),
      ),
    );
  }
}
