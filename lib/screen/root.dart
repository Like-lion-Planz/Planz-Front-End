import 'package:flutter/material.dart';
import 'package:planz/screen/concern/consulting.dart';
import 'package:planz/screen/home/schedule.dart';
import 'package:planz/screen/option.dart';
import 'package:planz/screen/prac.dart';


class RootTab extends StatefulWidget {
  static String get routeName => 'home';

  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    controller.dispose();
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: [
          SchedulePage(),
          Example(),
          Consulting(),
          Option(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/bottomnavicon/shedule.png"),
            label: '스케줄',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/bottomnavicon/sleep.png"),
            label: '수면기록',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/bottomnavicon/conc.png"),
            label: '고민해결',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/bottomnavicon/setting.png"),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
