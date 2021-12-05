import 'package:date_picker_timeline/date_picker_widget.dart'
    as DatePickerTimeline;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DatePickerTimeline.DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.blueAccent,
            selectedTextColor: Colors.white,
            onDateChange: (DateTime date) {
              setState(() {
                _selectedDate = date;
              });
            },
          )
        ],
      ),
    );
  }
}
