import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/home/schedule.dart';
import 'package:planz/screen/register/habit_select.dart';
import 'package:planz/screen/root.dart';
import 'package:http/http.dart' as http;

import '../../widget/routinecreate.dart';

class ScheduleInputScreen extends StatefulWidget {
  const ScheduleInputScreen({super.key});

  @override
  State<ScheduleInputScreen> createState() => _ScheduleInputScreenState();
}

class _ScheduleInputScreenState extends State<ScheduleInputScreen> {
  final storage = FlutterSecureStorage();
  List<bool> isSelected = [true, false, false, false];
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> routines = [];
  List<Map<String, dynamic>> currentSchedules = [];
  int selectedRoutineIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: BODY_TEXT_COLOR,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HabitSelectionScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: 1.0,
              backgroundColor: HINT_TEXT_COLOR,
              color: primaryColor,
            ),
            SizedBox(height: 22,),
            Text('고정 스케줄을 입력해 주세요',
                style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text('근무, 수업, 알바 등 고정된 스케줄을 추가해 주세요. 준비 및 이동 \n시간을 포함해 입력하면 정확한 수면 시간을 계획할 수 있어요.',
            style: TextStyle(color: Colors.grey),),
            SizedBox(height: 24,),
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
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => RootTab()));

              },
              style: ElevatedButton.styleFrom(
                foregroundColor : primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('완료',
                style: TextStyle(
                  color: backgroundColor,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 28,),
          ],
        ),
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
          //fetchSchedules(index + 1); // Adjust index to start from 1 when fetching schedules
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
            //fetchSchedules(selectedRoutineIndex + 1); // Fetch schedules with index starting from 1
          }
        });
      } else {
        throw Exception('Failed to load routines');
      }
    } catch (e) {
      print('Error fetching routines: $e');
    }
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
}
