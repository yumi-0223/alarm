import 'package:alarm/login_page.dart';
import 'package:flutter/material.dart';
import 'firebase_init.dart'; // Firebase初期化関数をインポート
import 'digitalcontents-alarm/pages/start/start.dart';
import 'digitalcontents-alarm/pages/mypage/my_page.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Coreのインポート

// Firebase設定を追加（Firebaseコンソールで取得した設定を使用）
const firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyACRVjGQRd5ZCnuEW3Igo-MgDMJNKWqrFg",
    authDomain: "sleep-f3c99.firebaseapp.com",
    projectId: "sleep-f3c99",
    storageBucket: "sleep-f3c99.firebasestorage.app",
    messagingSenderId: "977661455250",
    appId: "1:977661455250:web:bed4752a6f51523d336f4b",
    measurementId: "G-Z6EDCTSY6Y");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 必須：Flutterアプリの初期化前に呼び出し
  await Firebase.initializeApp(
      options: firebaseOptions); // Firebaseの初期化にオプションを渡す
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
      home: AuthPage(), // homeにLoginPageを指定
    );
  }
}
