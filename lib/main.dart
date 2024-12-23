<<<<<<< HEAD
import 'package:alarm/login_page.dart';
=======
import 'package:alarm/digitalcontents-alarm/pages/start/start.dart';
>>>>>>> 535ef42e7ef90ae5e9deed1642843ea9c2514139
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
<<<<<<< HEAD
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
=======
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Start(), // 初期画面
>>>>>>> 535ef42e7ef90ae5e9deed1642843ea9c2514139
    );
  }
}
