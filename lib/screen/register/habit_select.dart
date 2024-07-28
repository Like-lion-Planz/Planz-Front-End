import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/register/name_input.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/register/schedule_input.dart';

class Habit {
  final String id;
  final String label;
  final String imagePath;
  bool isSelected;

  Habit({required this.id, required this.label, required this.imagePath, this.isSelected = false});
  @override
  String toString() {
    return '$id';
  }
}

class Nutraceuticals{
  final String id;
  final String label;
  bool isSelected;

  Nutraceuticals({required this.id, required this.label, this.isSelected = false});

  @override
  String toString(){
    return '$id';
  }
}

class HabitSelectionScreen extends StatefulWidget {
  @override
  State<HabitSelectionScreen> createState() => _HabitSelectionScreenState();
}

class _HabitSelectionScreenState extends State<HabitSelectionScreen> {

  final List<Habit> habits = [
    Habit(id: 'caffeine', label: '카페인이 들어간 음료를 자주 마셔요', imagePath : 'assets/images/habit/coffee.png'),
    Habit(id: 'alcohol', label: '술을 자주 마셔요', imagePath: 'assets/images/habit/drink.png'),
    Habit(id: 'smoking', label: '흡연 습관이 있어요', imagePath: 'assets/images/habit/smoke.png'),
    Habit(id: 'exercise', label: '격한 운동을 자주 해요',imagePath: 'assets/images/habit/dribbble.png'),
    Habit(id: 'digital', label: '전자기기를 많이 사용해요',imagePath: 'assets/images/habit/smartphone.png'),
    Habit(id: 'nutrients', label: '영양제를 챙겨 먹어요',imagePath: 'assets/images/habit/pill.png'),
  ];

  final List<Nutraceuticals> Nutrients = [
    Nutraceuticals(id: 'vitaminB', label: '비타민B'),
    Nutraceuticals(id: 'vitaminD', label: '비타민D'),
    Nutraceuticals(id: 'omega3', label: '오메가3'),
    Nutraceuticals(id: 'coenzyme', label: '코엔자임'),
    Nutraceuticals(id: 'supplement', label: '운동 보충제'),
    Nutraceuticals(id: 'no', label: '해당 없음'),
  ];

  bool get isHabitNull{
    return habits.any((habit) => habit.isSelected);
  }

  bool get isNutrientsNull {
    return Nutrients.any((nutrients) => nutrients.isSelected);
  }

  List<Habit> get selectedHabits {
    return habits.where((habit) => habit.isSelected).toList();
  }

  List<Nutraceuticals> get selectedNutrients {
    return Nutrients.where((nutrients) => nutrients.isSelected).toList();
  }

  List<Habit> _selectedHabits = [];
  List<Nutraceuticals> _selectedNutrients = [];

  void updateSelections() {
    _selectedHabits = selectedHabits;
    _selectedNutrients  = selectedNutrients ;
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
                updateSelections();
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
                                    updateSelections();
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
              onPressed: () {
                if (isHabitNull && (!habits.last.isSelected || isNutrientsNull)) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleInputScreen()));
                }
                print( _selectedHabits);
                print(_selectedNutrients);
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
