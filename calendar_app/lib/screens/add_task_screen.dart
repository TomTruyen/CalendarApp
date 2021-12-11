import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/services/task_service.dart';
import 'package:calendar_app/services/theme_service.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:calendar_app/shared/toast.dart';
import 'package:calendar_app/shared/widgets/button.dart';
import 'package:calendar_app/shared/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Function refresh;

  const AddTaskScreen({Key? key, required this.refresh}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskService _taskService = TaskService.instance;
  final ThemeService _themeService = ThemeService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(minutes: 15));
  Color _selectedColor = const Color(0xFF4e5ae8);

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
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Add Task",
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
                    label: "Create Task",
                    onTap: () async {
                      Task task = Task();

                      task.title = _titleController.text;
                      task.note = _noteController.text;
                      task.date = _selectedDate;
                      task.startTime = _startTime;
                      task.endTime = _endTime;
                      task.color = _selectedColor;

                      if ((await _taskService.insert(task)).id != null) {
                        Toast.display(context, message: "Task added!");

                        widget.refresh();

                        if (Navigator.canPop(context)) Navigator.pop(context);
                      } else {
                        Toast.display(context, message: "Failed to add task.");
                      }
                    },
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

  _datePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildBottomPicker(
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            dateOrder: DatePickerDateOrder.dmy,
            onDateTimeChanged: (DateTime date) {
              if (mounted) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
          ),
        );
      },
    );
  }

  _timePicker({required bool isStartTime}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildBottomPicker(
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: isStartTime ? _startTime : _endTime,
            dateOrder: DatePickerDateOrder.dmy,
            minimumDate: isStartTime ? DateTime.now() : _startTime,
            onDateTimeChanged: (DateTime time) {
              if (mounted) {
                setState(() {
                  if (isStartTime) {
                    _startTime = time;
                  } else {
                    _endTime = time;
                  }

                  // Extra step to make sure the endTime is always after the starttime
                  if (_endTime.isBefore(_startTime)) _endTime = _startTime;
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 200.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
