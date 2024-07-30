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
  List<Map<String, dynamic>> routines = [];
  List<Map<String, dynamic>> currentSchedules = [];
  int selectedRoutineIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchRoutines();
  }

  Future<void> fetchRoutines() async {
    final response = await http.get(Uri.parse('http://43.203.110.28:8080/api/routines'));
    if (response.statusCode == 200) {
      setState(() {
        routines = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
      fetchSchedules(routines[0]['id']);
    } else {
      throw Exception('Failed to load routines');
    }
  }

  Future<void> fetchSchedules(int routineId) async {
    final response = await http.get(Uri.parse('http://43.203.110.28:8080/api/routines/$routineId/schedules'));
    if (response.statusCode == 200) {
      setState(() {
        currentSchedules = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load schedules');
    }
  }

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
      body: routines.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                              selectedRoutineIndex = index;
                              fetchSchedules(routines[selectedRoutineIndex]['id']);
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
                ElevatedButton(onPressed: () {
                  _showScheduleForm();
                }, child: Text("추가하기"))
              ],
            ),
            SizedBox(height: 16),
            ...currentSchedules.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> schedule = entry.value;
              return _buildScheduleItem(
                  schedule['content'], schedule['time'], schedule['notification_is_true'], index);
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

  Future<void> _showScheduleForm() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('스케줄 추가', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                decoration: InputDecoration(labelText: '스케줄 입력'),
              ),
              // Add your time picker and calendar selection widgets here
              ElevatedButton(
                onPressed: () {
                  // Add routine logic here
                  setState(() {
                    routines.add({'name': '새 루틴 ${routines.length + 1}'});
                    isSelected.add(false);
                  });
                  Navigator.pop(context);
                },
                child: Text('저장'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createRoutine(String routineName, TimeOfDay startTime, TimeOfDay endTime, List<DateTime> selectedDates) async {
    final url = 'http://43.203.110.28:8080/api/routines';
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: schedulelist,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          Icons.check_box_outline_blank,
          color: hasAlarm ? Colors.red : Colors.white,
        ),
        title: Text(title),
        subtitle: Text(time),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            _showEditScheduleForm(index);
          },
        ),
      ),
    );
  }

  Future<void> _showEditScheduleForm(int index) async {
    // Implement the edit schedule form
  }
}
