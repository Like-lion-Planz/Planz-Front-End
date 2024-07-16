import 'package:flutter/material.dart';
import 'package:planz/screen/register/name_input.dart';

Future<void> main() async {
  runApp(
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => NFCProvider()),
    //
    //   ],
      MaterialApp(
        // theme: ThemeData(
        //     fontFamily: "HancomMalangMalang-Bold",
        //     appBarTheme: AppBarTheme(
        //       backgroundColor: backgroundColor,
        //
        //     ),
        //     scaffoldBackgroundColor: Colors.white,
        //     sliderTheme: SliderThemeData(
        //         thumbColor: primaryColor,
        //         activeTickMarkColor: primaryColor,
        //         inactiveTickMarkColor: primaryColor.withOpacity(0.3)
        //     ),
        //     bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //       selectedItemColor: primaryColor,
        //       unselectedItemColor: secondaryColor,
        //       backgroundColor: backgroundColor,
        //     )
        // ),
        home : NameInputScreen(),
    ),
  );
}
