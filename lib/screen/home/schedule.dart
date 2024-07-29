import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../../widget/routinecreate.dart';
import '../../const/color.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<bool> isSelected = [true, false, false, false]; // Default selection for routines including Routine4
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> routines = [
    {
      'name': '데이 ☀️',
      'schedules': [
        {'title': '기상', 'time': '오전 08:00', 'hasAlarm': true},
        {'title': '아침 운동', 'time': '오전 10:00', 'hasAlarm': false},
      ]
    },
    {
      'name': '이브닝 🌕',
      'schedules': [
        {'title': '이브닝 운동', 'time': '오후 05:00', 'hasAlarm': true},
        {'title': '저녁 식사', 'time': '오후 07:00', 'hasAlarm': false},
      ]
    },
    {
      'name': '나이트 🌙',
      'schedules': [
        {'title': '밤 산책', 'time': '오후 09:00', 'hasAlarm': true},
        {'title': '취침', 'time': '오후 11:00', 'hasAlarm': false},
      ]
    },
    {
      'name': '주말 🍹',
      'schedules': [
        {'title': '브런치', 'time': '오전 11:00', 'hasAlarm': true},
        {'title': '산책', 'time': '오후 02:00', 'hasAlarm': false},
        {'title': '영화 관람', 'time': '오후 07:00', 'hasAlarm': true},
      ]
    },
  ];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    // Handle cases where isSelected may be empty or all false
    int selectedIndex = isSelected.indexOf(true);
    if (selectedIndex == -1 || selectedIndex >= routines.length) {
      selectedIndex = 0; // Default to the first routine if none is selected or index is out of bounds
    }

    List<Map<String, dynamic>> currentSchedules = routines[selectedIndex]['schedules'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Planz'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  Text(
                    DateFormat('M월 d일, 오늘').format(selectedDate),
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...routines.asMap().map((index, routine) {
                    return MapEntry(
                      index,
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ToggleButtons(
                          children: [
                            _buildRoutineTab(index + 1, routine['name']),
                          ],
                          isSelected: [isSelected.length > index ? isSelected[index] : false],
                          onPressed: (int buttonIndex) {
                            setState(() {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] = i == index;
                              }
                            });
                          },
                          fillColor: primaryColor,
                          selectedColor: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }).values.toList(),
                  _buildAddRoutineButton(context),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('오늘의 스케줄', style: TextStyle(fontSize: 18)),
                ElevatedButton(onPressed: () {}, child: Text("추가하기"))
              ],
            ),
            SizedBox(height: 16),
            ...currentSchedules.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> schedule = entry.value;
              return _buildScheduleItem(
                  schedule['title'], schedule['time'], schedule['hasAlarm'],
                  index);
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: '스케줄',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bedtime),
            label: '수면기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: '고민해결',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildRoutineTab(int index, String label) {
    return Center(
      child: Container(
        height: 82,
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Column(
          children: [
            Text(
              '루틴 $index',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            Text(
              '$label',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRoutineButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: GestureDetector(
        onTap: () => _showAddRoutineForm(context),
        child: Container(
          height: 82,
          width: 72,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            "asset/img/button/routineaddbutton.png",
            height: 82, width: 72,
          ),
        ),
      ),
    );
  }

  Future<void> _showAddRoutineForm(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: schedulelist,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return RoutineBottomSheet(
          onSave: (String routineName, TimeOfDay startTime, TimeOfDay endTime, List<DateTime> selectedDates) {
            _createRoutine(routineName, startTime, endTime, selectedDates);
          },
        );
      },
    );
  }

  Future<void> _createRoutine(String routineName, TimeOfDay startTime, TimeOfDay endTime, List<DateTime> selectedDates) async {
    final url = 'https://your-api-url.com/routines';
    final body = json.encode({
      'title': routineName,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'dates': selectedDates.map((date) => date.toIso8601String()).toList(),
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      setState(() {
        routines.add({
          'name': routineName,
          'schedules': [],
        });
        isSelected.add(false);
      });
    } else {
      throw Exception('Failed to create routine');
    }
  }

  Widget _buildScheduleItem(String title, String time, bool hasAlarm, int index) {
    return Container(
      height: 48,
      width: 345,
      padding: EdgeInsets.only(left: 20, right: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: schedulelist,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: Colors.teal),
              SizedBox(width: 8),
              Container(child: Text(title, style: TextStyle(fontSize: 14, color: Colors.white)), width: 76),
              SizedBox(width: 8),
              Container(
                width: 1,
                height: 24,
                color: Color(0xFF515863),
              ),
              SizedBox(width: 8),
              Container(child: Text(time, style: TextStyle(fontSize: 14, color: Colors.white)), width: 140),
            ],
          ),
          IconButton(
            icon: Icon(
              hasAlarm ? Icons.alarm : Icons.alarm_off,
              color: Colors.teal,
            ),
            onPressed: () {
              setState(() {
                routines[isSelected.indexOf(true)]['schedules'][index]['hasAlarm'] = !hasAlarm;
              });
            },
          ),
        ],
      ),
    );
  }
}
