import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Concern {
  final String imagePath;
  final String title;
  final String label;

  Concern({
    required this.imagePath,
    required this.title,
    required this.label,
  });
}

class Consulting extends StatefulWidget {
  const Consulting({super.key});

  @override
  State<Consulting> createState() => _ConsultingState();
}

final List<String> concerns = [
  '수면민감성', '수면부족', '코골이', '식곤증', '잠꼬대', '낮잠', '악몽'
];

class _ConsultingState extends State<Consulting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: SearchBar(
              leading: Icon(Icons.search, color: Colors.white, size: 40, ),
              backgroundColor: MaterialStatePropertyAll(Color(0xff2F2F30)),
              shape: MaterialStateProperty.all(
                  ContinuousRectangleBorder(borderRadius: BorderRadius.circular(30))
              ),
              textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
              hintText: '수면에 대한 고민을 검색해 보세요',
              hintStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 160.0), // 검색창 아래로 패딩 추가
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24,),
                    Text('추천 검색어',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: 12,),
                    Wrap(
                      spacing: 10,
                      children: [
                        ...concerns.map((concern) => Chip(
                          backgroundColor: Color(0xFF515863),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0), // 원하는 값으로 변경

                          ),
                          label: Text(concern, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                        )),
                      ],
                    ),
                    SizedBox(height: 32,),
                    Text('가장 많은 고민', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: 14,),
                    ConcernInfo(),
                    SizedBox(height: 50,),
                    Text('님을 위한 추천 상담사', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: 14,),
                    Image.asset('assets/images/doctor/doctor1.png'),
                    SizedBox(height: 8,),
                    Image.asset('assets/images/doctor/doctor2.png'),
                    SizedBox(height: 8,),
                    Image.asset('assets/images/doctor/doctor3.png'),
                    SizedBox(height: 28,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ConcernInfo extends StatelessWidget {

  final List<Concern> concernInfo = [
    Concern(imagePath: 'assets/images/concern/nose.png', title: '코골이를 안 할 수 있는 방법이 있을까요?', label: '무엇보다 생활 습관 개선이 필요해요'),
    Concern(imagePath:'assets/images/concern/sleep.png', title: '안대와 귀마개가 없으면 잠들기 어려워요', label: '수면 중 소음과 빛에 민감한 것은 얕은 수면이 지속됨을 의미'),
    Concern(imagePath: 'assets/images/concern/nap.png', title:'낮잠을 너무 오래 자요', label: '가장 흔한 원인은 전날 밤 수면의 양이 부족했거나 수면의 '),
    // Concern(imagePath: 'assets/images/concern/nose.png', title: '코골이를 안 할 수 있는 방법이 있을까요?', label: '무엇보다 생활 습관 개선이 필요해요'),
    // Concern(imagePath:'assets/images/concern/sleep.png', title: '안대와 귀마개가 없으면 잠들기 어려워요', label: '수면 중 소음과 빛에 민감한 것은 얕은 수면이 지속됨을 의미'),
    // Concern(imagePath: 'assets/images/concern/nap.png', title:'낮잠을 너무 오래 자요', label: '가장 흔한 원인은 전날 밤 수면의 양이 부족했거나 수면의 '),
  ];

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    return Column(
      children: concernInfo.map((info) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.asset(info.imagePath, width: 88, height: 52),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.title,
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, maxLines: 1,),
                  Text(info.label,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis, maxLines: 1,),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
