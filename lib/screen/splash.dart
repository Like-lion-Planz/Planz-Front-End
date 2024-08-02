import 'dart:async';

import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 1000), () {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginScreen()
      )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 360,),
            //Text('spalsh '),
            Image.asset('assets/images/logo/simbolLogo.png', width: 60, height: 60,),
            Image.asset('assets/images/logo/typeLogo.png',width: 224, height: 58,),
          ],

        )
      ),
    );
  }
}
