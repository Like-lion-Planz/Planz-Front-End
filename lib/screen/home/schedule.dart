import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<bool> isSelected = [true, false, false]; // Default selection for routines
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> routines = [
    {
      'name': '데이 🌟',
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
    List<Map<String, dynamic>> currentSchedules =
    routines[isSelected.indexOf(true)]['schedules'];
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
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: ToggleButtons(
                          children: [
                            _buildRoutineTab(index + 1, routine['name']),
                          ],
                          isSelected: [isSelected[index]],
                          onPressed: (int buttonIndex) {
                            setState(() {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] = i == index;
                              }
                            });
                          },
                          fillColor: Colors.teal,
                          selectedColor: Colors.white,
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
            Text('오늘의 스케줄', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ...currentSchedules.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> schedule = entry.value;
              return _buildScheduleItem(
                  schedule['title'], schedule['time'], schedule['hasAlarm'], index);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Text(
        '루틴 $index\n$label',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildAddRoutineButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: GestureDetector(
        onTap: () => _showAddRoutineForm(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.add, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Future<void> _showAddRoutineForm(BuildContext context) async {
    TextEditingController routineNameController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('루틴 추가', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: routineNameController,
                  decoration: InputDecoration(
                    labelText: '루틴 이름 입력',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (routineNameController.text.isNotEmpty) {
                      setState(() {
                        routines.add({
                          'name': routineNameController.text,
                          'schedules': []
                        });
                        isSelected.add(false);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('저장'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleItem(String title, String time, bool hasAlarm, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: Colors.teal),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text(time, style: TextStyle(fontSize: 16)),
                ],
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
                routines[isSelected.indexOf(true)]['schedules'][index]['hasAlarm'] = !hasAlarm;
              });
            },
          ),
        ],
      ),
    );
  }
}

