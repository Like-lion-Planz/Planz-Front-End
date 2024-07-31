import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:planz/screen/home/schedule.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:planz/screen/prac.dart';
import 'package:planz/widget/routinecreate.dart';

import 'package:planz/screen/home/testhome.dart';


void main() async{
  await initializeDateFormatting();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Example(),
      // home: SchedulePage(),
    );
  }
}

