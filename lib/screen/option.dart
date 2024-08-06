import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';

class Option extends StatefulWidget {
  const Option({super.key});

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff18191A),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            leading: Image.asset('assets/images/myInfo.png', width: 36, height: 36,),
            title: Text('내 정보', style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
            trailing: Image.asset('assets/images/Right.png', width: 36, height: 36,),
          ),
          Divider(thickness: 20,height: 36, color: Color(0xff242526),),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text(
              '알림 설정',
              style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w800, height: 22/16),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text('수면 알림',
              style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('ON', style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
                  Image.asset('assets/images/Right.png', width: 36, height: 36,),
                ],
               ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text('서비스 공지 알림', style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ON', style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
                Image.asset('assets/images/Right.png', width: 36, height: 36,),
              ],
            ),
          ),
          // Divider(thickness: 36,height: 36, color: Color(0x101111),),
          Divider(thickness: 20,height: 36, color: Color(0xff242526),),
          // SizedBox(height: 25,),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text(
              '고객지원',
              style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w800, height: 22/16),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text('공지사항', style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
            trailing: Image.asset('assets/images/Right.png', width: 36, height: 36,),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text('고객센터', style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
            trailing: Image.asset('assets/images/Right.png', width: 36, height: 36,),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text('이용 가이드', style: TextStyle(fontSize: 16, color: Color(0xFFD1D9E2), fontFamily: 'SUIT', fontStyle: FontStyle.normal, fontWeight: FontWeight.w600, height: 22/16),),
            trailing: Image.asset('assets/images/Right.png', width: 36, height: 36,),
          ),
        ],
      )
    );
  }
}

