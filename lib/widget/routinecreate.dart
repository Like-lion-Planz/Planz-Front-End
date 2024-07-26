import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:intl/intl.dart';

class RoutineBottomSheet extends StatefulWidget {
  final Function(String routineName, List<DateTime> selectedDates) onSave;

  RoutineBottomSheet({required this.onSave});

  @override
  _RoutineBottomSheetState createState() => _RoutineBottomSheetState();
}

class _RoutineBottomSheetState extends State<RoutineBottomSheet> {
  final TextEditingController _routineNameController =
  TextEditingController(text: "데이 🌟");

  TimeOfDay _startTime = TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 16, minute: 0);

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<DateTime> _selectedDates = [
    DateTime(2024, 8, 5),
    DateTime(2024, 8, 6),
    DateTime(2024, 8, 12),
    DateTime(2024, 8, 13),
    DateTime(2024, 8, 19),
    DateTime(2024, 8, 26),
    DateTime(2024, 8, 27),
  ];

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '루틴 1',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          TextField(
            controller: _routineNameController,
            decoration: InputDecoration(
              labelText: '루틴의 이름을 입력하세요',
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text('시작'),
                  hourMinute12H(),
                ],
              ),
              Column(
                children: [
                  Text('종료'),
                  hourMinute12H(),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('해당 루틴이 적용되는 날짜를 모두 선택하세요'),
          SizedBox(height: 8),
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return _selectedDates.any((selectedDay) => isSameDay(selectedDay, day));
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;

                if (_selectedDates.contains(selectedDay)) {
                  _selectedDates.remove(selectedDay);
                } else {
                  _selectedDates.add(selectedDay);
                }
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

                    Row(
                      children: [
                        IconButton(
                          icon: Image.asset('asset/img/icon/left.png'),
                          onPressed: _onLeftArrowPressed,
                        ),
                        Text(
                          '${day.year}년 ${day.month}월',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        IconButton(
                          icon: Image.asset('asset/img/icon/right.png'),
                          onPressed: _onRightArrowPressed,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
            ),
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: schedulelist),
              todayDecoration: BoxDecoration(),
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              outsideDaysVisible: false,  // Hides the days outside the current month
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onSave(_routineNameController.text, _selectedDates);
              Navigator.pop(context);
            },
            child: Text('저장'),
          ),
        ],
      ),
    );
  }

  Widget hourMinute12H(){
    return new TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _focusedDay = time;
        });
      },
    );
  }
}