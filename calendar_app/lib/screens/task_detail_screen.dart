import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/services/theme_service.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:calendar_app/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final ThemeService _themeService = ThemeService();

  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    bool isDarkMode = await _themeService.isDarkTheme();

    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Task _task = widget.task;

    return Scaffold(
      appBar: _appBar(),
      body: Container(
        child: Text("TASK DETAIL PAGE ${_task.note}"),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: _isDarkMode ? Themes.darkStatus : Themes.lightStatus,
      ),
      leading: IconButton(
        splashRadius: 16,
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: _isDarkMode ? Colors.white : Colors.black,
          size: 16,
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      actions: <Widget>[
        IconButton(
          splashRadius: 16,
          icon: Icon(
            Icons.create_outlined,
            color: _isDarkMode ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () {
            Toast.display(context, message: "EDIT PAGE OPENING");
          },
        ),
        IconButton(
          splashRadius: 16,
          icon: Icon(
            Icons.delete_outlined,
            color: _isDarkMode ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () {
            Toast.display(context, message: "DELETE TASK POPUP");
          },
        )
      ],
    );
  }
}
