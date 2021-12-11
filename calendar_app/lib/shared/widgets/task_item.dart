import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/screens/task_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function refresh;

  const TaskItem({Key? key, required this.task, required this.refresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: task.color,
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(task.title, style: _textStyle()),
              Text(
                "${_formatTime(time: task.startTime)} - ${_formatTime(time: task.endTime)}",
                style: _textStyle(),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => TaskDetailScreen(
                task: task,
                refresh: refresh,
              ),
            ),
          );
        });
  }

  _formatTime({required DateTime time}) {
    return DateFormat("hh:mm a").format(time).toString();
  }

  _textStyle() {
    return const TextStyle(
      color: Color(0xFFF0F0F0),
    );
  }
}
