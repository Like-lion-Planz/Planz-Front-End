import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routine Bottom Sheet',
      home: RoutineHomePage(),
    );
  }
}

class RoutineHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routine Bottom Sheet'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => RoutineBottomSheet(),
            );
          },
          child: Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}

class RoutineBottomSheet extends StatefulWidget {
  @override
  _RoutineBottomSheetState createState() => _RoutineBottomSheetState();
}

class _RoutineBottomSheetState extends State<RoutineBottomSheet> {
  final TextEditingController _routineNameController =
  TextEditingController(text: "데이 🌟");

  TimeOfDay _startTime = TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 16, minute: 0);

  DateTime selectedDate = DateTime.now();
  List<DateTime> selectedDates = [
    DateTime(2024, 8, 5),
    DateTime(2024, 8, 6),
    DateTime(2024, 8, 12),
    DateTime(2024, 8, 13),
    DateTime(2024, 8, 19),
    DateTime(2024, 8, 26),
    DateTime(2024, 8, 27),
  ];

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
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
                '루틴 1',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text('시작'),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text('${_startTime.format(context)}'),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('종료'),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text('${_endTime.format(context)}'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('해당 루틴이 적용되는 날짜를 모두 선택하세요'),
          SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemCount: DateUtils.getDaysInMonth(2024, 8),
              itemBuilder: (context, index) {
                final date = DateTime(2024, 8, index + 1);
                final isSelected = selectedDates.any((d) =>
                d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedDates.removeWhere((d) =>
                        d.year == date.year &&
                            d.month == date.month &&
                            d.day == date.day);
                      } else {
                        selectedDates.add(date);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat.d().format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('저장'),
          ),
        ],
      ),
    );
  }
}
