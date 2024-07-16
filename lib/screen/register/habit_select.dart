import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/register/name_input.dart';
import 'package:planz/const/color.dart';


class Habit {
  final String label;
  bool isSelected;

  Habit({required this.label, this.isSelected = false});
  @override
  String toString() {
    return '$label: ${isSelected ? 'selected' : 'not selected'}';
  }
}


class HabitSelectionScreen extends StatefulWidget {
  @override
  State<HabitSelectionScreen> createState() => _HabitSelectionScreenState();
}

class _HabitSelectionScreenState extends State<HabitSelectionScreen> {

  final List<Habit> habits = [
    Habit(label: '카페인'),
    Habit(label: '술'),
    Habit(label: '담배'),
    Habit(label: '운동'),
    Habit(label: '전자기기'),
    Habit(label: '영양제'),
  ];

  void _printHabits() {
    for (var habit in habits) {
      print(habit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: BODY_TEXT_COLOR),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NameInputScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: 0.4, // Adjust this value as needed
              backgroundColor: HINT_TEXT_COLOR,
              color: primaryColor,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '생활 습관을 선택해 주세요',
              style: TextStyle(
                color: BODY_TEXT_COLOR,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '평소 습관을 고려한 생활 수칙을 알려 드릴게요.',
              style: TextStyle(
                color: HINT_TEXT_COLOR,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            ...habits.map((habit) => HabitButton(habit: habit, onSelected: () {
              setState(() {});
            })).toList(),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => HabitSelectionScreen()));
                _printHabits();
              },
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '다음',
                style: TextStyle(
                  color: backgroundColor,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class HabitButton extends StatelessWidget {
  final Habit habit;
  final VoidCallback onSelected;

  HabitButton({required this.habit, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          habit.isSelected = !habit.isSelected;
          onSelected();
          print(habit);
        },
        style: ElevatedButton.styleFrom(
          primary: habit.isSelected ? primaryColor : buttonColor,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                habit.label,
                style: TextStyle(
                  color: habit.isSelected ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}