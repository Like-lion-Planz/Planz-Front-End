import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planz/screen/root.dart';
import '../register/name_input.dart';

class KakaoLoginScreen extends StatefulWidget {
  @override
  _KakaoLoginScreenState createState() => _KakaoLoginScreenState();
}

class _KakaoLoginScreenState extends State<KakaoLoginScreen> {

  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final storage = FlutterSecureStorage();
  final String clientId = 'e6d0bdc9bcbafaf3442ca214d97e8a84';
  final String redirectUri = 'http://43.203.110.28:8080/api/login/oauth2/kakao';
  final String kakaoAuthUrl = 'https://kauth.kakao.com/oauth/authorize';

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();

    // WebView의 URL 변화를 감지합니다.
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.startsWith(redirectUri)) {
        final uri = Uri.parse(url);
        final code = uri.queryParameters['code'];
        print("코드: $code");
        if (code != null) {
          await _getTokensFromBackend(code);
          flutterWebviewPlugin.close(); // 인증 후 웹뷰를 닫습니다.
        }
      }
    });
  }

  Future<void> _checkAutoLogin() async {
    try {
      // 토큰이 존재하는지 확인합니다.
      final accessToken = await storage.read(key: "ACCESS_TOKEN");

      if (accessToken != null) {
        // 토큰 유효성을 확인합니다.
        if (await _validateToken(accessToken)) {
          // 토큰이 유효하다면 다음 화면으로 이동합니다.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RootTab()),
          );
        } else {
          // 토큰이 유효하지 않다면 삭제합니다.
          await storage.delete(key: "ACCESS_TOKEN");
          await storage.delete(key: "REFRESH_TOKEN");
        }
      }
    } catch (e) {
      print('자동 로그인 확인 중 오류 발생: $e');
    }
  }

  Future<bool> _validateToken(String accessToken) async {
    try {
      // 실제 API 호출로 토큰을 유효성 검사합니다.
      final response = await http.get(
        Uri.parse('https://kapi.kakao.com/v1/user/access_token_info'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('토큰 유효성 검사 중 오류 발생: $e');
      return false;
    }
  }

  Future<void> _getTokensFromBackend(String code) async {
    try {
      final response = await http.get(
        Uri.parse('http://43.203.110.28:8080/api/login/oauth2/kakao?code=$code'),
      );

      print('응답 상태: ${response.statusCode}');
      print('응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = jsonDecode(response.body);

        if (data != null && data.containsKey('userTokenDto')) {
          final tokenData = data['userTokenDto'];

          if (tokenData != null) {
            final accessToken = tokenData['accessToken'];
            final refreshToken = tokenData['refreshToken'];
            await storage.write(key: "REFRESH_TOKEN", value: refreshToken);
            await storage.write(key: "ACCESS_TOKEN", value: accessToken);
            print('Access Token: $accessToken');
            print('Refresh Token: $refreshToken');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NameInputScreen()),
            );
          } else {
            print('응답에 토큰 데이터가 없습니다.');
          }
        } else {
          print('응답에 예상된 "userTokenDto" 키가 없습니다.');
        }
      } else {
        print('로그인 실패, 상태 코드: ${response.statusCode}');
        print('응답 본문: ${response.body}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: '$kakaoAuthUrl?client_id=$clientId&redirect_uri=$redirectUri&response_type=code',
      appBar: AppBar(
        title: Text('Kakao Login'),
      ),
      withJavascript: true,
    );
  }
}
