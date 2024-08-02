import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/home/testhome.dart';
import 'package:planz/screen/register/name_input.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert';

import 'package:planz/screen/root.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 156,),
            Container(
              margin: EdgeInsets.fromLTRB(41,0,0,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('바쁜 당신을 위한\n수면 스케줄 관리',
                    style: TextStyle(fontSize: 30, color: primaryColor, fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 42/30),),
                  SizedBox(height: 28,),
                  Image.asset('assets/images/logo/typeLogo.png', width: 244, height: 63,),
                ],
              ),
            ),
            SizedBox(height: 332,),
            GestureDetector(child: Image.asset('assets/images/login/kakao.png',  width: 336, height: 56,),
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => KakaoLoginScreen()));
              },),
            SizedBox(height: 16,),
            Image.asset('assets/images/login/google.png', width: 336, height: 56,),
            SizedBox(height: 26,),
          ],

        ),
      ),
    );
  }
}