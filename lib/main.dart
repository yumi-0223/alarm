import 'package:alarm/login_page.dart';
import 'package:flutter/material.dart';
import 'firebase_init.dart'; // Firebase初期化関数をインポート
import 'digitalcontents-alarm/pages/start/start.dart';
import 'digitalcontents-alarm/pages/mypage/my_page.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Coreのインポート

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutterの初期化

  // Firebaseの初期化を呼び出し、エラーをキャッチして表示する
  await initializeFirebase();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyPage(), // 初期画面を設定
    );
  }
}
