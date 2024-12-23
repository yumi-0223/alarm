import 'package:alarm/digitalcontents-alarm/pages/start/start.dart';
import 'package:flutter/material.dart';
import 'digitalcontents-alarm/pages/mypage/my_page.dart';
import 'digitalcontents-alarm/pages/start/start.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Start(), // 初期画面
    );
  }
}
