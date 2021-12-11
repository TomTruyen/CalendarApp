import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/screens/task_screen.dart';
import 'package:calendar_app/services/notification_service.dart';
import 'package:calendar_app/services/task_service.dart';
import 'package:calendar_app/services/theme_service.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:calendar_app/shared/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function refresh;

  const TaskDetailScreen({Key? key, required this.task, required this.refresh})
      : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskService _taskService = TaskService.instance;
  final ThemeService _themeService = ThemeService();

  bool _isDarkMode = false;

  Task _task = Task();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    bool isDarkMode = await _themeService.isDarkTheme();

    setState(() {
      _isDarkMode = isDarkMode;
      _task = widget.task;
    });
  }

  void refresh(Task task) {
    setState(() {
      _task = task;
    });

    widget.refresh();
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => TaskScreen(
                  refresh: refresh,
                  isEdit: true,
                  editTask: _task,
                ),
              ),
            );
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
          onPressed: () async {
            if (await _showDeletePopup()) {
              if (Navigator.canPop(context)) Navigator.pop(context);
            }
          },
        )
      ],
    );
  }

  Future _showDeletePopup() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          title: const Text(
            "Delete this task?",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor.withAlpha(50),
                ),
                foregroundColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor,
                ),
              ),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red.withAlpha(50),
                ),
                foregroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red,
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                if (await _taskService.delete(widget.task.id) > 0) {
                  Toast.display(context, message: "Task deleted!");

                  NotificationService().cancelScheduledNotification(
                    widget.task,
                  );

                  widget.refresh();

                  if (Navigator.canPop(context)) Navigator.pop(context, true);
                } else {
                  Toast.display(context, message: "Failed to delete task.");

                  if (Navigator.canPop(context)) Navigator.pop(context, false);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
