import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/screens/task_screen.dart';
import 'package:calendar_app/services/globals.dart';
import 'package:calendar_app/services/notification_service.dart';
import 'package:calendar_app/services/task_service.dart';
import 'package:calendar_app/shared/popup.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:calendar_app/shared/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function refresh;

  const TaskDetailScreen({Key? key, required this.task, required this.refresh})
      : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final Globals _globals = Globals();
  final TaskService _taskService = TaskService.instance;

  Task _task = Task();

  @override
  void initState() {
    _task = widget.task;
    super.initState();
  }

  void refresh(Task task) {
    setState(() {
      _task = task;
    });

    widget.refresh();
  }

  String _formatTime({required DateTime time}) {
    return DateFormat("hh:mm a").format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _task.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: headingStyle,
                ),
              ),
              _detailItem(
                const Icon(Icons.calendar_today_outlined),
                DateFormat.yMMMMd().format(_task.date),
              ),
              _detailItem(
                const Icon(Icons.access_time_rounded),
                "${_formatTime(time: _task.startTime)} - ${_formatTime(time: _task.endTime)}",
              ),
              if (_task.note != "")
                _detailItem(const Icon(Icons.notes_rounded), _task.note),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        splashRadius: 16,
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: _globals.isDarkMode ? Colors.white : Colors.black,
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
            color: _globals.isDarkMode ? Colors.white : Colors.black,
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
          },
        ),
        IconButton(
          splashRadius: 16,
          icon: Icon(
            Icons.delete_outlined,
            color: _globals.isDarkMode ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () async {
            if (await _showDeletePopup() ?? false) {
              if (Navigator.canPop(context)) Navigator.pop(context);
            }
          },
        )
      ],
    );
  }

  Widget _detailItem(Icon icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
            ),
          ),
        ],
      ),
    );
  }

  _showDeletePopup() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Popup(
          title: "Delete this task?",
          cancelText: 'Cancel',
          cancelColor: Theme.of(context).primaryColor,
          cancel: () {
            Navigator.of(context).pop();
          },
          okText: 'Delete',
          okColor: Colors.red,
          ok: () async {
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
        );
      },
    );
  }
}
