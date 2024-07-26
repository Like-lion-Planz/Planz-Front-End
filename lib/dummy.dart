import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends StatefulWidget {
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onLeftArrowPressed() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _onRightArrowPressed() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Table Calendar'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, day) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${day.year}년 ${day.month}월',
                  style: TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _onLeftArrowPressed,
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: _onRightArrowPressed,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyCalendar(),
  ));
}
