import 'package:flutter/material.dart';
import 'package:planz/const/color.dart';
import 'package:planz/screen/home/testhome.dart';
import 'package:planz/screen/register/name_input.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  // Future<void> _loginWithKakao(BuildContext context) async {
  //   final clientId = 'e6d0bdc9bcbafaf3442ca214d97e8a84';
  //   final redirectUri = 'http://localhost:8080/api/login/oauth2/kakao';
  //
  //   final result = await FlutterWebAuth.authenticate(
  //     url: 'https://kauth.kakao.com/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code',
  //     callbackUrlScheme: 'myapp',
  //   );
  //
  //   final code = Uri.parse(result).queryParameters['code'];
  //
  //   final response = await http.post(
  //     Uri.parse('http://43.203.110.28:8080/oauth2/authorization/kakao'),
  //     body: {'code': code},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final tokens = json.decode(response.body);
  //     final accessToken = tokens['accessToken'];
  //     final refreshToken = tokens['refreshToken'];
  //
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage(user: tokens)),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Login Failed')),
  //     );
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 156,),
            Container(
              margin: EdgeInsets.fromLTRB(41,0,0,0),
              child: Column(
                children: [
                  Text('바쁜 당신을 위한\n수면 스케줄 관리',
                    style: TextStyle(fontSize: 30, color: primaryColor),),
                  SizedBox(height: 24,),
                  Image.asset('assets/images/logo/typeLogo.png', width: 244, height: 63,),
                ],
              ),

            ),

            SizedBox(height: 330,),
            GestureDetector(child: Image.asset('assets/images/login/kakao.png'),onTap: () {
            },),
            SizedBox(height: 16,),
            Image.asset('assets/images/login/google.png'),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NameInputScreen()));
            }, child: Text('임시버튼')),
          ],

        ),
      ),
    );
  }
}
