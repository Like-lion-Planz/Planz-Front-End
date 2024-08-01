import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:planz/const/color.dart';
import 'package:planz/widget/time%20picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutineBottomSheet extends StatefulWidget {
  final Function(String routineName, DateTime startTime, DateTime endTime, List<DateTime> selectedDates) onSave;

  RoutineBottomSheet({required this.onSave});

  @override
  _RoutineBottomSheetState createState() => _RoutineBottomSheetState();
}

class _RoutineBottomSheetState extends State<RoutineBottomSheet> {
  final TextEditingController _routineNameController = TextEditingController(text: "데이");
  DateTime? _startTime;
  DateTime? _endTime;
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedDates = [];

  void _handleStartTimeChanged(DateTime newTime) {
    setState(() {
      _startTime = newTime;
      print(_startTime);
    });
  }

  void _handleEndTimeChanged(DateTime newTime) {
    setState(() {
      _endTime = newTime;
      print(_endTime);
    });
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
                '루틴 생성',
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
            children: [
              Column(
                children: [
                  Text('시작',style: TextStyle(color: primaryColor),),
                  Container(child: CustomTimePicker(
                    onTimeChanged: _handleStartTimeChanged,
                    initialTime: DateTime(2016, 5, 10, 1, 0),
                  ),)

                ],
              ),
              Column(
                children: [
                  Text('종료', style:TextStyle(color: primaryColor)),
                  Container(child: CustomTimePicker(
                    onTimeChanged: _handleEndTimeChanged,
                    initialTime: DateTime(2016, 5, 10, 1, 0),
                  ),)
                ],
              ),
            ],
            // children: [
            //   Expanded(
            //     child: Column(
            //       children: [
            //         Text('시작 시간'),
            //         TextButton(
            //           onPressed: () => _selectTime(context, true),
            //           child: Text('${_startTime.format(context)}'),
            //         ),
            //       ],
            //     ),
            //   ),
            //   Expanded(
            //     child: Column(
            //       children: [
            //         Text('종료 시간'),
            //         TextButton(
            //           onPressed: () => _selectTime(context, false),
            //           child: Text('${_endTime.format(context)}'),
            //         ),
            //       ],
            //     ),
            //   ),
            // ],
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
                          icon: Icon(Icons.arrow_left),
                          onPressed: _onLeftArrowPressed,
                        ),
                        Text(
                          '${day.year}년 ${day.month}월',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_right),
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
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(),
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              outsideDaysVisible: false,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onSave(_routineNameController.text, _startTime!, _endTime!, _selectedDates);
              Navigator.pop(context);
            },
            child: Text('저장'),
          ),
        ],
      ),
    );
  }
  Widget hourMinute12HCustomStyle(){
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.deepOrange
      ),
      highlightedTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.yellow
      ),
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _focusedDay = time;
        });
      },
    );
  }

  Widget timePicker()
  {
    DateTime time = DateTime(2016, 5, 10, 22, 35);
    return CupertinoDatePicker(
      initialDateTime: time,
      mode: CupertinoDatePickerMode.time,
      use24hFormat: true,
      onDateTimeChanged: (DateTime newTime) {
        setState(() => time = newTime);
      },
    );
  }
}
