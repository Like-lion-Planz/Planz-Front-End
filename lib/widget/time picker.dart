import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:planz/const/color.dart';

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
          // Sets the primary color for selected text in the date picker
          textTheme: CupertinoTextThemeData(
            // Sets the color for unselected text in the date picker
            dateTimePickerTextStyle: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          // Additional theme settings if needed
        ),
        child: Container(
          width: 148,
          height: 116,
          color: schedulelist,
          child: CupertinoDatePicker(
            backgroundColor: Color(0xFF37363a), // Set the background color of the picker
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
      ),
    );
  }
}