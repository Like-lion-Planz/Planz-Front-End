import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Topbutton extends StatefulWidget {
  @override
  State<Topbutton> createState() => _TopbuttonState();
}

class _TopbuttonState extends State<Topbutton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        height: 58,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context); // 뒤로가기 버튼을 눌렀을 때 이전 화면으로 이동
                },
                icon: Icon(Icons.arrow_back), // 뒤로가기 버튼
              ),
            ],
          ),
        ),
      ),
    );
  }
}