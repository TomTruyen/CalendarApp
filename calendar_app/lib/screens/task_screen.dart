import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/services/notification_service.dart';
import 'package:calendar_app/services/task_service.dart';
import 'package:calendar_app/services/theme_service.dart';
import 'package:calendar_app/shared/popup.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:calendar_app/shared/toast.dart';
import 'package:calendar_app/shared/widgets/button.dart';
import 'package:calendar_app/shared/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  final Function refresh;
  final bool isEdit;
  final Task? editTask;

  const TaskScreen({
    Key? key,
    required this.refresh,
    this.isEdit = false,
    this.editTask,
  }) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskService _taskService = TaskService.instance;
  final ThemeService _themeService = ThemeService();

  int? _id;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _startTime = DateTime.now().add(const Duration(minutes: 1));
  DateTime _endTime = DateTime.now().add(const Duration(minutes: 16));
  Color _selectedColor = const Color(0xFF4e5ae8);

  bool _isEdit = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    bool isDarkMode = await _themeService.isDarkTheme();

    setState(() {
      _isDarkMode = isDarkMode;
      _isEdit = widget.isEdit;

      _id = widget.editTask?.id;
      _titleController = TextEditingController(
        text: widget.editTask?.title ?? "",
      );
      _noteController = TextEditingController(
        text: widget.editTask?.note ?? "",
      );
      _selectedDate = widget.editTask?.date ?? DateTime.now();
      _startTime = widget.editTask?.startTime ??
          DateTime.now().add(
            const Duration(minutes: 1),
          );
      _endTime = widget.editTask?.endTime ??
          DateTime.now().add(
            const Duration(minutes: 16),
          );
      _selectedColor = widget.editTask?.color ?? const Color(0xFF4e5ae8);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _isEdit ? "Edit Task" : "Add Task",
                style: headingStyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat('dd/MM/yyyy').format(_selectedDate),
                widget: Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
                onClick: () => _datePicker(),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _formatTime(time: _startTime),
                      widget: Container(
                        padding: const EdgeInsets.only(right: 8),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      onClick: () => _timePicker(isStartTime: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _formatTime(time: _endTime),
                      widget: Container(
                        padding: const EdgeInsets.only(right: 8),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      onClick: () => _timePicker(isStartTime: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Color",
                        style: titleStyle,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        children: List<Widget>.generate(
                          3,
                          (index) {
                            Color color = Colors.grey;

                            if (index == 0) color = const Color(0xFF4e5ae8);
                            if (index == 1) color = const Color(0xFFFFB746);
                            if (index == 2) color = const Color(0xFFFF4667);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: color,
                                  child: _selectedColor == color
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : Container(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Button(
                    label: _isEdit ? "Edit Task" : "Create Task",
                    onTap: () => _saveTask(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _formatTime({required DateTime time}) {
    return DateFormat("hh:mm a").format(time).toString();
  }

  _saveTask() async {
    if (_titleController.text.isEmpty) {
      _showError("Title can't be empty.");
      return;
    }

    if (_selectedDate.isBefore(DateTime.now())) {
      _showError("Date can't be in the past.");
      return;
    }

    if (_startTime.isBefore(DateTime.now())) {
      _showError("Start time can't be in the past.");
      return;
    }

    if (_endTime.isBefore(_startTime)) {
      _showError("End time must be after the start time.");
      return;
    }

    Task task = Task();

    task.title = _titleController.text;
    task.note = _noteController.text;
    task.date = _selectedDate;
    task.startTime = _startTime;
    task.endTime = _endTime;
    task.color = _selectedColor;

    if (_isEdit) {
      task.id = _id;

      if ((await _taskService.update(task)) > 0) {
        Toast.display(context, message: "Task updated!");

        NotificationService().cancelScheduledNotification(task);
        NotificationService().scheduleNotification(task);

        widget.refresh(task);

        if (Navigator.canPop(context)) Navigator.pop(context);
      } else {
        Toast.display(context, message: "Failed to edit task.");
      }
    } else {
      if ((await _taskService.insert(task)).id != null) {
        Toast.display(context, message: "Task added!");

        NotificationService().scheduleNotification(task);

        widget.refresh();

        if (Navigator.canPop(context)) Navigator.pop(context);
      } else {
        Toast.display(context, message: "Failed to add task.");
      }
    }
  }

  _showError(String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Popup(
          title: "Error!",
          content: content,
          hideCancel: true,
          okText: 'Okay',
          okColor: Theme.of(context).primaryColor,
          ok: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        );
      },
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
    );
  }

  _datePicker() async {
    FocusScope.of(context).unfocus();

    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      cancelText: "Cancel",
      confirmText: "Okay",
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (date != null && date != _selectedDate) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  _timePicker({required bool isStartTime}) async {
    FocusScope.of(context).unfocus();

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(_startTime)
          : TimeOfDay.fromDateTime(_endTime),
      cancelText: "Cancel",
      confirmText: "Okay",
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
          timePickerTheme: TimePickerThemeData(
            dayPeriodBorderSide: BorderSide(
              color: Theme.of(context).primaryColor.withAlpha(50),
            ),
          ),
        ),
        child: child!,
      ),
    );

    if (time != null && mounted) {
      setState(() {
        DateTime now = DateTime.now();
        if (isStartTime) {
          _startTime =
              DateTime(now.year, now.month, now.day, time.hour, time.minute);
        } else {
          _endTime =
              DateTime(now.year, now.month, now.day, time.hour, time.minute);
        }

        if (_endTime.isBefore(_startTime)) _endTime = _startTime;
      });
    }
  }
}
