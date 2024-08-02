import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:planz/widget/time%20picker.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final Function(String content, DateTime notificationTime) onSave;

  ScheduleBottomSheet({required this.onSave});

  @override
  _ScheduleBottomSheetState createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final TextEditingController _contentController = TextEditingController();
  DateTime _notificationTime = DateTime.now();

  void _handleTimeChanged(DateTime newTime) {
    setState(() {
      _notificationTime = newTime;
      print(_notificationTime);
    });
  }

  bool get _isSaveButtonEnabled => _contentController.text.isNotEmpty;

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
                '스케줄 추가',
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
            controller: _contentController,
            decoration: InputDecoration(
              labelText: '스케줄 입력',
            ),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 16),
          Column(
            children: [
              Text('알림 시간', style: TextStyle(color: Colors.black)),
              Container(
                child: CustomTimePicker(
                  onTimeChanged: _handleTimeChanged,
                  initialTime: _notificationTime,
                ),
              )
            ],
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSaveButtonEnabled
                ? () {
              widget.onSave(
                _contentController.text,
                _notificationTime,
              );
            }
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(345, 28),
              foregroundColor: Colors.white,
              backgroundColor: _isSaveButtonEnabled ? Colors.blue : Colors.grey,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}
