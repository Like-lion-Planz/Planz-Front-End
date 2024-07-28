import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/register/habit_select.dart';

class ScheduleInputScreen extends StatelessWidget {
  const ScheduleInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: BODY_TEXT_COLOR,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HabitSelectionScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: 1.0,
              backgroundColor: HINT_TEXT_COLOR,
              color: primaryColor,
            ),
            SizedBox(height: 22,),
            Text('고정 스케줄을 입력해 주세요',
                style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text('근무, 수업, 알바 등 고정된 스케줄을 추가해 주세요. 준비 및 이동 \n시간을 포함해 입력하면 정확한 수면 시간을 계획할 수 있어요.',
            style: TextStyle(color: Colors.grey),),
            SizedBox(height: 24,),

            Spacer(),
            ElevatedButton(
              onPressed: (){

              },
              style: ElevatedButton.styleFrom(
                foregroundColor : primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('완료',
                style: TextStyle(
                  color: backgroundColor,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 28,),
          ],
        ),
      ),
    );
  }
}
