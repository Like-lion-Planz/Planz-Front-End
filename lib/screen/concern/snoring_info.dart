import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/concern/consulting.dart';

class SnoringInfoScreen extends StatelessWidget {
  const SnoringInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Row(
          children: [
            SizedBox(width: 8,),
            IconButton(
              icon: Icon(CupertinoIcons.back, color: BODY_TEXT_COLOR,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Consulting()));
              },
            ),

          ],
        ),
        actions: [
          Image.asset('assets/images/concern/link.png', width: 24, height: 24,),
          SizedBox(width: 20,),
          Image.asset('assets/images/concern/share.png', width: 24, height: 24,),
          SizedBox(width: 30,),
        ],
      ),
      body: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40,),
            Text('코골이를 안 할 수 있는\n 방법이 있을까요?',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
            SizedBox(height: 32,),
            Image.asset('assets/images/concern/noseInfo.png'),
            SizedBox(height: 24,),
            Text('코골이를 줄이기 위해서는 옆으로 자는 자세를 유지하고 체중을 관리하며, 알코올과 진정제를 피하는 것이 중요합니다. 규칙적인 수면 습관을 유지하고 코 막힘을 완화하며 충분한 수분을 섭취하는 것도 도움이 됩니다. 비강 확장기와 구강 내 장치를 사용하고, 수면 무호흡증이 있다면 전문적인 치료를 받으세요. 흡연은 기도에 염증을 유발하므로 금연이 필요합니다.',
            style: TextStyle(color: Colors.white, fontSize: 14),),
            SizedBox(height: 24,),
            Text('* 콘텐츠의 내용은 의사 및 간호사의\n의학적 지식을 자문 받아 제작되었습니다.',
              style: TextStyle(color: Colors.grey, fontSize: 12) ,),
          ],
        ),
      ),
    );
  }
}
