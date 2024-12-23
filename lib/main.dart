import 'package:alarm/login_page.dart';
import 'package:alarm/digitalcontents-alarm/pages/start/start.dart';
import 'package:flutter/material.dart';
import 'firebase_init.dart'; // Firebase初期化関数をインポート
import 'digitalcontents-alarm/pages/mypage/my_page.dart';
import 'digitalcontents-alarm/pages/start/start.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(); // Firebaseの初期化を呼び出し
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}
