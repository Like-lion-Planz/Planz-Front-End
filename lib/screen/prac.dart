import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // For date formatting

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
  final storage = FlutterSecureStorage();
  dynamic name = '';
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, Feeling> _selectedFeelings = {};


  final List<Feeling> feelings = [
    Feeling(
        id: 'happy',
        imagePath: 'assets/images/feeling/lively.png',
        label: '활기차요'),
    Feeling(
        id: 'refreshing',
        imagePath: 'assets/images/feeling/refreshing.png',
        label: '상쾌해요'),
    Feeling(id: 'easy', imagePath: 'assets/images/feeling/easy.png', label: '무난해요'),
    Feeling(id: 'tired', imagePath: 'assets/images/feeling/tired.png', label: '피곤해요'),
    Feeling(
        id: 'annoying',
        imagePath: 'assets/images/feeling/annoying.png',
        label: '짜증나요'),
  ];

  Future<void> fetchData() async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      if(accessToken == null){
        throw Exception('Access token is not available');
      }
      final response = await http.get(
        Uri.parse('http://43.203.110.28:8080/api/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if(response.statusCode == 200){
        setState(() {
          name = responseData['name'];
        });
        print(name);
      }
    } catch (e) {
      print('error fetching: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _fetchSleepRecords(_focusedDay).then((_) {
      if (_selectedFeelings[DateTime.now()] == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showFeelingSelectionSheet(context);
        });
      }
    });
  }

  Future<void> _fetchSleepRecords(DateTime date) async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');

      if (accessToken == null) {
        throw Exception('Access token is not available');
      }

      final startOfMonth = DateTime(date.year, date.month, 1);
      DateTime endOfMonth;

      if (date.month == DateTime.now().month && date.year == DateTime.now().year) {
        // 현재 월이 선택된 월과 동일할 경우, 오늘 날짜로 endOfMonth 설정
        endOfMonth = DateTime.now().subtract(Duration(days: 1)); // 오늘을 제외한 전날까지
      } else {
        // 일반적인 경우: 선택된 월의 마지막 날
        endOfMonth = DateTime(date.year, date.month + 1, 0);
      }

      final Map<DateTime, Feeling> fetchedFeelings = {};

      for (DateTime day = startOfMonth; day.isBefore(endOfMonth.add(Duration(days: 1))); day = day.add(Duration(days: 1))) {
        final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(day.toLocal());
        final url = Uri.parse('http://43.203.110.28:8080/api/sleepLog/')
            .replace(queryParameters: {'date': formattedDate});
        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );
        print(response.body);
        if (response.statusCode == 200) {
          final List<dynamic> records = jsonDecode(response.body);
          for (var record in records) {
            final int timestamp = record['date'];
            final DateTime recordDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
            final String mood = record['mood'];
            fetchedFeelings[recordDate] = _getFeelingByMood(mood);
          }
        } else {
          print('Failed to load sleep records for $day: ${response.statusCode}');
        }
      }

      setState(() {
        _selectedFeelings = fetchedFeelings;
      });
    } catch (e) {
      print('Error fetching sleep records: $e');
    }
  }

  Feeling _getFeelingByMood(String mood) {
    // Return the appropriate Feeling object based on mood
    switch (mood) {
      case 'happy':
        return feelings.firstWhere((feeling) => feeling.id == 'happy');
      case 'refreshing':
        return feelings.firstWhere((feeling) => feeling.id == 'refreshing');
      case 'easy':
        return feelings.firstWhere((feeling) => feeling.id == 'easy');
      case 'tired':
        return feelings.firstWhere((feeling) => feeling.id == 'tired');
      case 'annoying':
        return feelings.firstWhere((feeling) => feeling.id == 'annoying');
      default:
        return feelings.firstWhere((feeling) => feeling.id == 'easy');
    }
  }

  void _onLeftArrowPressed() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
      _fetchSleepRecords(_focusedDay);
    });
  }

  void _onRightArrowPressed() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
      _fetchSleepRecords(_focusedDay);
    });
  }

  Future<void> _showFeelingSelectionSheet(BuildContext context) async {
    Feeling? _selectedFeeling;

    await showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('기분 선택',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ...feelings.map((feeling) => Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedFeeling = feeling;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            children: [
                              Image.asset(
                                feeling.imagePath,
                                width: 24,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                feeling.label,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2F2F30),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: _selectedFeeling == feeling ? Colors.blue : Colors.transparent,
                              width: 1,
                            )),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _selectedFeeling == null ? null : () {
                      if (_selectedDay != null && _selectedFeeling != null) {
                        setState(() {
                          _selectedFeelings[_selectedDay!] = _selectedFeeling!;
                        });
                        print('Request Body: Day: $_selectedDay, Feeling: $_selectedFeeling');
                        _saveMoodToServer(_selectedDay!, _selectedFeeling!);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '저장',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedFeeling == null ? Colors.grey : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((_) {
      setState(() {});
    });
  }

  Future<void> _saveMoodToServer(DateTime date, Feeling feeling) async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      if (accessToken == null) {
        throw Exception('Access token is not available');
      }
      final url = 'http://43.203.110.28:8080/api/sleepLog/addLog';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'date': date.toIso8601String(),
          'mood': feeling.id,
          'sleepTime': 8 * 60, // Replace with actual sleep time if needed
        }),
      );
      print(jsonEncode({
        'date': date.toIso8601String(),
        'mood': feeling.id,
        'sleepTime': 8 * 60, // Replace with actual sleep time if needed
      }));

      if (response.statusCode == 200) {
        print('Mood saved successfully');
      } else {
        print('Failed to save mood: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving mood: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            child: TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                if (selectedDay.isBefore(DateTime.now())) {
                  //_showPastDayForm(context, selectedDay);
                  _showFeelingSelectionSheet(context);
                } else {
                  //_showFeelingSelectionSheet(context);
                }
              },
              headerStyle: const HeaderStyle(
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
                            icon: const Icon(
                              Icons.arrow_left,
                              size: 35,
                            ),
                            onPressed: _onLeftArrowPressed,
                          ),
                          Text(
                            '${day.month}월',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_right,
                              size: 35,
                            ),
                            onPressed: _onRightArrowPressed,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  Feeling? feeling = _selectedFeelings[day];
                  return Column(
                    children: [
                      Text(
                        day.day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (feeling != null)
                        Image.asset(
                          feeling.imagePath,
                          width: 30,
                          height: 30,
                        )
                      else
                        Image.asset(
                          'assets/images/feeling/default.png',
                          width: 30,
                          height: 30,
                        ),
                    ],
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  Feeling? feeling = _selectedFeelings[day];
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          day.day.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (feeling != null)
                          Image.asset(
                            feeling.imagePath,
                            width: 30,
                            height: 30,
                          )
                        else
                          Image.asset(
                            'assets/images/feeling/default.png',
                            width: 30,
                            height: 30,
                          ),
                      ],
                    ),
                  );
                },
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white),
                weekendStyle: TextStyle(color: Colors.white),
              ),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false, // 오늘 날짜 강조를 비활성화
                selectedDecoration: BoxDecoration(
                  color: Colors.transparent, // 선택된 날짜 배경색을 투명으로 설정
                ),
                selectedTextStyle: TextStyle(color: Colors.white), // 선택된 날짜 텍스트 색상
                todayTextStyle: TextStyle(color: Colors.white), // 오늘 날짜 텍스트 색상
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
                outsideDaysVisible: false,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                   Text(
                    '$name님을 위한 생활 수칙',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Image.asset('assets/images/rule/caffeRule.png'),
                  const SizedBox(
                    height: 8,
                  ),
                  Image.asset('assets/images/rule/smokeRule.png'),
                  const SizedBox(
                    height: 8,
                  ),
                  Image.asset('assets/images/rule/vitaminRule.png'),
                  const SizedBox(
                    height: 8,
                  ),
                  Image.asset('assets/images/rule/drinkRule.png'),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}