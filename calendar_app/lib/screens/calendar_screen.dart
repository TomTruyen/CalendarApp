import 'package:calendar_app/models/task.dart';
import 'package:calendar_app/screens/add_task_screen.dart';
import 'package:calendar_app/services/task_service.dart';
import 'package:calendar_app/shared/themes.dart';
import 'package:calendar_app/shared/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_widget.dart'
    as DatePickerTimeline;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  final TaskService _taskService = TaskService.instance;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _taskBar(),
          _datePicker(),
          Expanded(
            child: _taskList(),
          )
        ],
      ),
    );
  }

  Widget _taskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          Button(
            label: "+ Add Task",
            onTap: () => {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const AddTaskScreen()),
              ),
            },
          )
        ],
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePickerTimeline.DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: Theme.of(context).primaryColor,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (DateTime date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Widget _taskList() {
    return FutureBuilder(
      future: _taskService.getByDate(_selectedDate),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            Task task = snapshot.data[index];
            return Column(
              children: <Widget>[
                Text(task.title),
              ],
            );
          },
        );
      },
    );
  }
}
