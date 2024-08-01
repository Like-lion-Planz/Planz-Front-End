import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/register/name_input.dart';
import 'package:planz/screen/register/schedule_input.dart';

class Habit {
  final String label;
  final String imagePath;
  bool isSelected;

  Habit({required this.label, required this.imagePath, this.isSelected = false});

  @override
  String toString() {
    return '$label';
  }
}

class Nutraceuticals{
  final String label;
  bool isSelected;

  Nutraceuticals({required this.label, this.isSelected = false});

  @override
  String toString(){
    return '$label';
  }
}

class HabitSelectionScreen extends StatefulWidget {
  @override
  State<HabitSelectionScreen> createState() => _HabitSelectionScreenState();
}

class _HabitSelectionScreenState extends State<HabitSelectionScreen> {
  final storage = FlutterSecureStorage();
  bool alcohol = false;
  bool coenzyme = false;
  bool coffee = false;
  bool electronicDevices = false;
  bool exerciseSupplements = false;
  bool omega3 = false;
  bool smoking = false;
  bool tonic = false;
  bool vitaminb = false;
  bool vitamind = false;

  Future<void> _createHabits () async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN'); // Correct key

      if (accessToken == null) {
        throw Exception('Access token is not available');
      }

      final url = 'http://43.203.110.28:8080/api/user/habits';
      final body = json.encode({
        "alcohol": alcohol,
        "coenzyme": coenzyme,
        "coffee": coffee,
        "electronicDevices": electronicDevices,
        "exerciseSupplements": exerciseSupplements,
        "omega3": omega3,
        "smoking": smoking,
        "tonic": tonic,
        "vitaminb": vitaminb,
        "vitamind": vitamind,
      });

      print(body);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      print(response.body);
      if (response.statusCode == 200) {

      } else {
        throw Exception('Failed to create habits');
      }
    } catch (e) {
      print('Error creating habits: $e');
    }
  }


  final List<Habit> habits = [
    Habit(label: '카페인이 들어간 음료를 자주 마셔요', imagePath : 'assets/images/habit/coffee.png'),
    Habit(label: '술을 자주 마셔요', imagePath: 'assets/images/habit/drink.png'),
    Habit(label: '흡연 습관이 있어요', imagePath: 'assets/images/habit/smoke.png'),
    Habit(label: '격한 운동을 자주 해요',imagePath: 'assets/images/habit/dribbble.png'),
    Habit(label: '전자기기를 많이 사용해요',imagePath: 'assets/images/habit/smartphone.png'),
    Habit(label: '영양제를 챙겨 먹어요',imagePath: 'assets/images/habit/pill.png'),
  ];

  final List<Nutraceuticals> Nutrients = [
    Nutraceuticals(label: '비타민B'),
    Nutraceuticals(label: '비타민D'),
    Nutraceuticals(label: '오메가3'),
    Nutraceuticals(label: '코엔자임'),
    Nutraceuticals(label: '운동 보충제'),
    Nutraceuticals(label: '해당 없음'),
  ];

  bool get isHabitNull{
    return habits.any((habit) => habit.isSelected);
  }

  bool get isNutrientsNull {
    return Nutrients.any((nutrients) => nutrients.isSelected);
  }

  // List<Habit> get selectedHabits {
  //   return habits.where((habit) => habit.isSelected).toList();
  // }
  //
  // List<Nutraceuticals> get selectedNutrients {
  //   return Nutrients.where((nutrients) => nutrients.isSelected).toList();
  // }

  // List<Habit> _selectedHabits = [];
  // List<Nutraceuticals> _selectedNutrients = [];
  //
  // void updateSelections() {
  //   _selectedHabits = selectedHabits;
  //   _selectedNutrients  = selectedNutrients ;
  // }

  void updateHabitStates() {
    for (var habit in habits) {
      switch (habit.label) {
        case '카페인이 들어간 음료를 자주 마셔요':
          coffee = habit.isSelected;
          break;
        case '술을 자주 마셔요':
          alcohol = habit.isSelected;
          break;
        case '흡연 습관이 있어요':
          smoking = habit.isSelected;
          break;
        case '격한 운동을 자주 해요':
          exerciseSupplements = habit.isSelected;
          break;
        case '전자기기를 많이 사용해요':
          electronicDevices = habit.isSelected;
          break;
        case '영양제를 챙겨 먹어요':
          tonic = habit.isSelected;
          break;
      }
    }

    for (var nutrient in Nutrients) {
      switch (nutrient.label) {
        case '비타민B':
          vitaminb = nutrient.isSelected;
          break;
        case '비타민D':
          vitamind = nutrient.isSelected;
          break;
        case '오메가3':
          omega3 = nutrient.isSelected;
          break;
        case '코엔자임':
          coenzyme = nutrient.isSelected;
          break;
        case '운동 보충제':
          exerciseSupplements = nutrient.isSelected;
          break;
      }
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
              value: 0.7,
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
              '평소 습관을 고려한 생활 수칙을 알려 드려요.',
              style: TextStyle(
                color: HINT_TEXT_COLOR,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            ...habits.map((habit) => HabitButton(habit: habit, onSelected: () {
              setState(() {
                // updateSelections();
                // print( _selectedHabits);
              });
            })).toList(),
            SizedBox(height: 20,),
            Visibility(
                visible: habits.last.isSelected,
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        Text('평소 챙겨 먹는 영양제 중 해당되는 것을 선택해 주세요',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        SizedBox(height: 12,),
                        Wrap(
                          spacing: 8,
                          children: [
                            ...Nutrients.map((nutrients) => ElevatedButton(
                                onPressed:(){
                                  setState(() {
                                    nutrients.isSelected = !nutrients.isSelected;
                                    // updateSelections();
                                    // print(_selectedNutrients);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff2F2F30),
                                  side: BorderSide(
                                    color: nutrients.isSelected ? primaryColor : Color(0xff2F2F30),
                                    width: 3,
                                  ),
                                ),
                                child: Text(nutrients.label,
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )
                            )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (isHabitNull && (!habits.last.isSelected || isNutrientsNull)) {
                  updateHabitStates();
                  await _createHabits();
                  _createHabits;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleInputScreen()));
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor : primaryColor,

                backgroundColor : isHabitNull && (!habits.last.isSelected || isNutrientsNull) ? primaryColor : buttonColor,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 28),

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
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff2F2F30),
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: habit.isSelected ? primaryColor : Color(0xff2F2F30),
              width: 3,
            )
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset(
                habit.imagePath,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(width: 10,),
            Expanded(child: Text(habit.label, style: TextStyle(
              fontSize: 18, color: Colors.white,
            ),
              textAlign: TextAlign.left,))
          ],
        ),
      ),
    );
  }
}
