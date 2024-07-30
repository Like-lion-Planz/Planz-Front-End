import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

class KakaoLoginScreen extends StatefulWidget {
  @override
  _KakaoLoginScreenState createState() => _KakaoLoginScreenState();
}

class _KakaoLoginScreenState extends State<KakaoLoginScreen> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final String clientId = 'e6d0bdc9bcbafaf3442ca214d97e8a84';
  final String redirectUri = 'http://43.203.110.28:8080/api/login/oauth2/kakao';
  final String kakaoAuthUrl = 'https://kauth.kakao.com/oauth/authorize';

  @override
  void initState() {
    super.initState();

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

  Future<void> _getTokensFromBackend(String code) async {
    try {
      final response = await http.get(
        Uri.parse('http://43.203.110.28:8080/api/login/oauth2/kakao?code=$code'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = jsonDecode(response.body);

        if (data != null && data.containsKey('token')) {
          final tokenData = data['token'];

          if (tokenData != null) {
            final accessToken = tokenData['accessToken'];
            final refreshToken = tokenData['refreshToken'];
            print('Access Token: $accessToken');
            print('Refresh Token: $refreshToken');
            // 여기서 추가적인 처리나 페이지 이동을 할 수 있습니다.
          } else {
            print('Token data is missing in the response.');
          }
        } else {
          print('Response does not contain expected "token" key.');
        }
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
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
