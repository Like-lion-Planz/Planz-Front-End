import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planz/widget/emptyappbar.dart';
import '../../widget/routinecreate.dart';
import '../../const/color.dart';
import '../../widget/schedulebottom.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final storage = FlutterSecureStorage();
  List<bool> isSelected = [true, false, false, false];
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
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      if (accessToken == null) {
        throw Exception('Access token is not available');
      }

      final response = await http.get(
        Uri.parse('https://3611-118-42-152-155.ngrok-free.app/api/routine'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNjM0MzI1NDc0IiwibmFtZSI6Iuy1nOuqheyerCIsImlhdCI6MTcyMjYwODk2NCwiZXhwIjoxNzIyNjEyNTY0fQ.SyTMHqWIPRCQQvlvcDKFPsPlS4URHTBsPXqfcPZAgyY',
        },
      );

      print(jsonDecode(utf8.decode(response.bodyBytes)));
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          routines =
          List<Map<String, dynamic>>.from(jsonDecode(utf8.decode(response.bodyBytes)));

          if (routines.isNotEmpty) {
            fetchSchedules(selectedRoutineIndex + 1); // Fetch schedules with index starting from 1
          }
        });
      } else {
        throw Exception('Failed to load routines');
      }
    } catch (e) {
      print('Error fetching routines: $e');
    }
  }

  Future<void> fetchSchedules(int routineId) async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      if (accessToken == null) {
        throw Exception('Access token is not available');
      }

      final response = await http.get(
        Uri.parse('https://3611-118-42-152-155.ngrok-free.app/api/routine/$routineId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNjM0MzI1NDc0IiwibmFtZSI6Iuy1nOuqheyerCIsImlhdCI6MTcyMjYwODk2NCwiZXhwIjoxNzIyNjEyNTY0fQ.SyTMHqWIPRCQQvlvcDKFPsPlS4URHTBsPXqfcPZAgyY',
        },
      );

      print(response.statusCode);
      print(jsonDecode(utf8.decode(response.bodyBytes)));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
        jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          currentSchedules = List<Map<String, dynamic>>.from(
              responseData['toDoList'].map((item) {
                return {
                  'time': item['time'] ?? '00:00:00', // null 값을 '00:00:00'으로 대체
                  'content': item['content'] ?? 'No Content', // null 값을 'No Content'으로 대체
                  'toDoId': item['toDoId'] ?? 0, // null 값을 0으로 대체
                  'notification_is_true': item['notification_is_true'] ?? false, // null 값을 false로 대체
                };
              }));
        });
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      print('Error fetching schedules: $e');
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                  ),
                  Image.asset(
                    "assets/images/logo/type_logo_grey.png",
                    width: 80,
                    height: 21,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 43,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ]),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: routines.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> routine = entry.value;
                      return _buildRoutineTab(index, routine['routineName']);
                    }).toList()
                      ..add(_buildAddRoutineButton(context)),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('오늘의 스케줄', style: TextStyle(fontSize: 18)),
                    SizedBox(
                      width: 146,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showScheduleForm();
                      },
                      child: Text("추가하기"),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ...currentSchedules.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> schedule = entry.value;
                  return _buildScheduleItem(
                    schedule['content'],
                    schedule['time'],
                    schedule['notification_is_true'],
                    index,
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineTab(int index, String label) {
    bool isSelected = selectedRoutineIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRoutineIndex = index;
          print(selectedRoutineIndex);
          fetchSchedules(index + 1); // Adjust index to start from 1 when fetching schedules
        });
      },
      child: Center(
        child: Container(
          height: 82,
          width: 72,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Color(0xFF2f2f30), // Change color if selected
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '루틴 ${index + 1}', // Display routine index starting from 1
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                '$label',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddRoutineButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
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
            height: 82,
            width: 72,
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
          onSave: (String routineName, DateTime startTime, DateTime endTime,
              List<DateTime> selectedDates) {
            createRoutine(routineName, startTime, endTime, selectedDates);
          },
        );
      },
    );
  }

  Future<void> _showScheduleForm() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ScheduleBottomSheet(
          onSave: (String content, DateTime notificationTime) {
            createschedule(selectedRoutineIndex + 1, content,
                notificationTime); // Adjust index to start from 1 when creating schedules
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> createRoutine(String routineName, DateTime startTime,
      DateTime endTime, List<DateTime> selectedDates) async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      if (accessToken == null) {
        throw Exception('Access token is not available');
      }

      print('Access Token: $accessToken');

      const url =
          'https://3611-118-42-152-155.ngrok-free.app/api/createRoutine';
      final body = json.encode({
        'title': routineName,
        'startTime': DateFormat('HH:mm:ss').format(startTime),
        'endTime': DateFormat('HH:mm:ss').format(endTime),
        'dates': selectedDates
            .map((date) => DateFormat('yyyy-MM-dd').format(date))
            .toList(),
      });
      print('Request body: $body');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNjM0MzI1NDc0IiwibmFtZSI6Iuy1nOuqheyerCIsImlhdCI6MTcyMjYwODk2NCwiZXhwIjoxNzIyNjEyNTY0fQ.SyTMHqWIPRCQQvlvcDKFPsPlS4URHTBsPXqfcPZAgyY',
      };
      print('Request headers: $headers');

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the new routine from response or use a placeholder
        final newRoutine = {
          'routineName': routineName,
          'schedules': [],
          // Include any other necessary fields returned from the response
        };

        setState(() {
          routines.add(newRoutine);
          isSelected.add(false);
          selectedRoutineIndex = routines.length - 1;
          fetchRoutines();// Select the newly created routine
        });

        fetchRoutines(); // Optionally re-fetch to confirm synchronization with the server
      } else {
        throw Exception('Failed to create routine');
      }
    } catch (e) {
      print('Error creating routine: $e');
    }
  }


  Widget _buildScheduleItem(
      String title, String time, bool hasAlarm, int index) {
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
              Container(
                child:
                Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
                width: 76,
              ),
              SizedBox(width: 8),
              Container(
                width: 1,
                height: 24,
                color: Color(0xFF515863),
              ),
              SizedBox(width: 8),
              Container(
                child: Text(time, style: TextStyle(fontSize: 14, color: Colors.white)),
                width: 140,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              hasAlarm ? Icons.alarm : Icons.alarm_off,
              color: Colors.teal,
            ),
            onPressed: () {
              setState(() {
                currentSchedules[index]['notification_is_true'] = !hasAlarm;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEditScheduleForm(int index) async {
    // Implement the edit schedule form
  }

  Future<void> createschedule(
      int routineId, String content, DateTime notificationTime) async {
    final String apiUrl =
        'https://3611-118-42-152-155.ngrok-free.app/api/routine/$routineId/create';
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      if (accessToken == null) {
        throw Exception('Access token is not available');
      }
      print('Access Token: $accessToken');
      print(notificationTime);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNjM0MzI1NDc0IiwibmFtZSI6Iuy1nOuqheyerCIsImlhdCI6MTcyMjYwODk2NCwiZXhwIjoxNzIyNjEyNTY0fQ.SyTMHqWIPRCQQvlvcDKFPsPlS4URHTBsPXqfcPZAgyY',
        },
        body: jsonEncode({
          'content': content,
          'time': DateFormat('HH:mm:ss').format(notificationTime),
        }),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        fetchSchedules(routineId);
        print('Responasdasdse body: ${response.body}');
      } else {
        throw Exception('Failed to create schedule');
      }
    } catch (e) {
      print('Error creating schedule: $e');
    }
  }
}
