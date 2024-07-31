import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planz/const/color.dart';
import 'package:planz/widget/routinecreate.dart';
import 'package:table_calendar/table_calendar.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class Feeling {
  final String id;
  final String imagePath;
  final String label;

  Feeling({required this.id, required this.imagePath, required this.label});
}

class _ExampleState extends State<Example> {
  DateTime _focusedDay = DateTime.now();
  List<DateTime> _selectedDates = [];

  final List<Feeling> feelings = [
    Feeling(id: 'lively', imagePath: 'assets/images/feeling/lively.png', label: '활기차요'),
    Feeling(id: 'refreshing', imagePath: 'assets/images/feeling/refreshing.png', label: '상쾌해요'),
    Feeling(id: 'easy', imagePath: 'assets/images/feeling/easy.png', label: '무난해요'),
    Feeling(id: 'tired', imagePath: 'assets/images/feeling/tired.png', label: '피곤해요'),
    Feeling(id: 'annoying', imagePath: 'assets/images/feeling/annoying.png', label: '짜증나요'),
  ];

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

  Future<void> _showPastdayForm(BuildContext context) async {
    String weekdayString = DateFormat.EEEE('ko_KR').format(_focusedDay);

    //임시 기분
    Feeling todayFeeling = feelings.firstWhere((feeling) => feeling.id == 'lively');

    await showModalBottomSheet(
        backgroundColor: schedulelist,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_focusedDay.month}월 ${_focusedDay.day}일 ${weekdayString}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () {
                      Navigator.pop(context);
                    }, icon: Icon(Icons.close, color: Colors.white, size: 30,)),
                  ],
                ),
                SizedBox(height: 24,),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('기상 후 기분', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                        SizedBox(height: 26,),
                        Row(
                          children: [
                            Image.asset(todayFeeling.imagePath, width: 36, height: 36,),
                            SizedBox(width: 12,),
                            Container(
                              width: 80,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: primaryColor,
                              ),
                              child:Text(todayFeeling.label,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),
                            )
                          ],
                        )

                      ],
                    ),
                    Container(
                      height: 74,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        )
                      ),

                    ),
                    Column(
                      children: [
                        Text('총 수면 시간', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                        SizedBox(height: 26,),
                        Container(
                          width: 80,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: primaryColor,
                          ),
                          child:Text('8시간',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        )
                      ],
                    ),

                  ]

                ),


                SizedBox(height: 60,),
              ],
            ),
          );
        }
    );
  }

  Future<void> _showTodayForm(BuildContext context) async {
    String weekdayString = DateFormat.EEEE('ko_KR').format(_focusedDay);

    await showModalBottomSheet(
      backgroundColor: schedulelist,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Add this line to make the bottom sheet fit its content
            children: [
              SizedBox(height: 24,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_focusedDay.month}월 ${_focusedDay.day}일 ${weekdayString}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: Icon(Icons.close, color: Colors.white, size: 30,)),
                ],
              ),
              SizedBox(height: 12,),
              Text('오늘 아침 기분은 어떠신가요?',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
              SizedBox(height: 18,),
              ...feelings.map((feeling) =>
                Column(
                  children: [
                    ElevatedButton(onPressed: (){},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                        children: [
                          Image.asset(feeling.imagePath, width: 24, height: 30,),
                          SizedBox(width: 16,),
                          Text(feeling.label, style: TextStyle(color: Colors.white, fontSize: 16),),
                        ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2F2F30),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: buttonColor,
                            width: 1,
                          )
                      ),),
                    SizedBox(height: 8,),
                  ],

                )
              ),
              SizedBox(height: 16,),
              Text('오늘 하루 총 몇 시간 수면 했나요?',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              //Timer
              SizedBox(height: 158,),
              ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  foregroundColor : primaryColor,
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('저장', style: TextStyle(
                  color: backgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              SizedBox(height: 28),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //임시 기분
    Feeling todayFeeling = feelings.firstWhere((feeling) => feeling.id == 'lively');
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50,),
          Container(
            child: TableCalendar(

              locale: 'ko_KR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              // selectedDayPredicate: (day) {
              //   return _selectedDates.any((selectedDay) => isSameDay(selectedDay, day));
              // },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  // if (_selectedDates.contains(selectedDay)) {
                  //   _selectedDates.remove(selectedDay);
                  // } else {
                  //   _selectedDates.add(selectedDay);
                  // }
                });

                if (isSameDay(selectedDay, DateTime.now())){
                  _showTodayForm(context);
                }else{
                  _showPastdayForm(context);
                }

              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left, size: 35,),
                            onPressed: _onLeftArrowPressed,
                          ),
                          Text(
                            '${day.month}월',
                            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right, size: 35,),
                            onPressed: _onRightArrowPressed,
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                    ],
                  );
                },
                defaultBuilder: (context, day, _focusedDay){
                  return Column(
                    children: [
                      Text(day.day.toString(), style: TextStyle(color: Colors.white),),
                      Image.asset('assets/images/feeling/default.png', width: 30, height: 30,),

                    ],
                  );
                }
              ),

              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
                weekendStyle: TextStyle(color: Colors.white),
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: primaryColor, // Underline color
                      width: 1.0,  // Underline width
                    ),
                  ),
                ),
                todayTextStyle: TextStyle(
                  color: primaryColor,  // Text color for today
                  fontWeight: FontWeight.bold,
                ),
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                outsideDaysVisible: false,
              ),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text('님을 위한 생활 수칙',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
                  SizedBox(height: 18,),
                  Image.asset('assets/images/rule/caffeRule.png'),
                  SizedBox(height: 8,),
                  Image.asset('assets/images/rule/smokeRule.png'),
                  SizedBox(height: 8,),
                  Image.asset('assets/images/rule/vitaminRule.png'),
                  SizedBox(height: 8,),
                  Image.asset('assets/images/rule/drinkRule.png'),
                  SizedBox(height: 8,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
