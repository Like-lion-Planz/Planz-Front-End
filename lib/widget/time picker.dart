import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(DateTime) onTimeChanged;
  final DateTime initialTime;

  CustomTimePicker({required this.onTimeChanged, required this.initialTime});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      width: 148,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        child: CupertinoDatePicker(
          backgroundColor: Colors.black,
          initialDateTime: _selectedTime,
          mode: CupertinoDatePickerMode.time,
          use24hFormat: false,
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              _selectedTime = newTime;
            });
            widget.onTimeChanged(newTime);
          },
        ),
      ),
    );
  }
}
