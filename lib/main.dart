import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'package:planz/screen/splash.dart';


void main() async{
  await initializeDateFormatting();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
          bodyMedium: TextStyle(
            fontFamily: 'SUIT',
          ),

        ),
      ),
      home: SplashScreen(),

    );
  }
}

