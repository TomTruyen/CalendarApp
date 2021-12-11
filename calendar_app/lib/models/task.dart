import 'package:calendar_app/services/task_service.dart';
import 'package:flutter/material.dart';

class Task {
  int? id;
  String title = "";
  String note = "";
  DateTime date = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(minutes: 15));
  Color color = const Color(0xFF4e5ae8);
  bool completed = false;

  Task();

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      TaskService.columnTitle: title,
      TaskService.columnNote: note,
      TaskService.columnDate: date.millisecondsSinceEpoch,
      TaskService.columnStartTime: startTime.millisecondsSinceEpoch,
      TaskService.columnEndTime: endTime.millisecondsSinceEpoch,
      TaskService.columnColor: color.value,
      TaskService.columnCompleted: completed ? 1 : 0
    };

    return map;
  }

  Task.fromMap(Map<String, Object?> map) {
    id = map[TaskService.columnId] as int;
    title = map[TaskService.columnTitle] as String;
    note = map[TaskService.columnNote] as String;
    date = DateTime.fromMillisecondsSinceEpoch(
      map[TaskService.columnDate] as int,
    );
    startTime = DateTime.fromMillisecondsSinceEpoch(
      map[TaskService.columnStartTime] as int,
    );
    endTime = DateTime.fromMillisecondsSinceEpoch(
      map[TaskService.columnEndTime] as int,
    );
    color = Color(map[TaskService.columnColor] as int);
    completed = (map[TaskService.columnCompleted] as int) == 1;
  }
}
