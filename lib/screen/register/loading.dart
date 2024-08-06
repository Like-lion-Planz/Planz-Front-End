import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planz/const/color.dart';
import 'package:http/http.dart' as http;
import 'package:planz/screen/root.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final storage = FlutterSecureStorage();
  String setname = "";

  @override
  void initState() {
    super.initState();
    getname();

    // Navigate to RootTab after a delay
    Timer(Duration(milliseconds: 3000), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RootTab(),
        ),
      );
    });
  }

  Future<void> getname() async {
    final name = await storage.read(key: 'name');
    setState(() {
      setname = name ?? ""; // Handle null value to prevent errors
      print(setname);
    });
  }

  // Future<void> fetchData() async {
  //   try {
  //     final accessToken = await storage.read(key: 'ACCESS_TOKEN');
  //     if (accessToken == null) {
  //       throw Exception('Access token is not available');
  //     }
  //     final response = await http.get(
  //       Uri.parse('http://43.203.110.28:8080/api/user'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );
  //
  //     final responseBody = utf8.decode(response.bodyBytes);
  //     print('Raw response: $responseBody');
  //
  //     if (response.statusCode == 200) {
  //       try {
  //         final responseData = jsonDecode(responseBody);
  //
  //         setState(() {
  //         });
  //       } catch (e) {
  //         print('Error parsing JSON: $e');
  //       }
  //     } else {
  //       print('Request failed with status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 232),
            Align(
              alignment: Alignment.center,
              child: Image.asset('assets/images/login/loading.png', width: 132),
            ),
            SizedBox(height: 40),
            Text(
              '$setname님에게 맞는 최적의\n수면 시간을 계획하고 있어요',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'SUIT',
                fontStyle: FontStyle.normal,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 34 / 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '잠시만 기다려 주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'SUIT',
                fontStyle: FontStyle.normal,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
