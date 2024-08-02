import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/home/schedule.dart';
import 'package:planz/screen/register/habit_select.dart';
import 'package:planz/screen/register/loading.dart';
import 'package:planz/screen/root.dart';

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
            SizedBox(height: 20,),
            Text('고정 스케줄을 입력해 주세요',
                style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 28, fontWeight: FontWeight.w700,
                    fontFamily: 'SUIT', fontStyle: FontStyle.normal),
            ),
            Text('근무, 수업, 알바 등 고정된 스케줄을 추가해 주세요. 준비 및 이동 시간을 포함해 입력하면 정확한 수면 시간을 계획할 수 있어요.',
            style: TextStyle(color: Colors.grey, fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontSize: 14, fontWeight: FontWeight.w600, height: 20/14, letterSpacing: -0.14),),
            SizedBox(height: 24,),
            //스케줄 추가 버튼
            SizedBox(height: 436,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoadingScreen()));

              },
              style: ElevatedButton.styleFrom(
                backgroundColor : buttonColor,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('완료',
                style: TextStyle(
                  color: backgroundColor,
                  fontSize: 20,
                    fontWeight: FontWeight.w700, height: 28/20,
                    fontFamily: 'SUIT', fontStyle: FontStyle.normal
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
