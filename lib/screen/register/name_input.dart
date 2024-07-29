import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:planz/screen/login.dart';
import 'package:planz/screen/register/habit_select.dart';
import 'package:planz/const/color.dart';


class NameInputScreen extends StatefulWidget {
  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: BODY_TEXT_COLOR),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: 0.3,
              backgroundColor: HINT_TEXT_COLOR,
              color: primaryColor,
            ),
            SizedBox(height: 16,),
            Text(
              '이름을 입력해 주세요',
              style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 24),
            ),
            Text(
              '플랜즈에서 어떻게 불러드릴까요?',
              style: TextStyle(color: HINT_TEXT_COLOR, fontSize: 16),
            ),
            TextFormField(
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: InputDecoration(border: InputBorder.none),
              style: TextStyle(fontSize: 32, color: BODY_TEXT_COLOR),
              onChanged: (String value){
                setState(() {
                  name = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (c) => HabitSelectionScreen())
                  );
                }
                print(name);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor : name.isNotEmpty ? primaryColor : buttonColor,
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
                  fontWeight: FontWeight.bold
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
