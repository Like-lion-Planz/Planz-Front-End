import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/register/name_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 156,),
            Container(
              margin: EdgeInsets.fromLTRB(41,0,0,0),
              child: Column(
                children: [
                  Text('바쁜 당신을 위한\n수면 스케줄 관리',
                    style: TextStyle(fontSize: 30, color: primaryColor),),
                  SizedBox(height: 24,),
                  Image.asset('assets/images/logo/typeLogo.png', width: 244, height: 63,),
                ],
              ),

            ),

            SizedBox(height: 330,),
            Image.asset('assets/images/login/kakao.png'),
            SizedBox(height: 16,),
            Image.asset('assets/images/login/google.png'),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NameInputScreen()));
            }, child: Text('임시버튼')),
          ],

        ),
      ),
    );
  }
}
