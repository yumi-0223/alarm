import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'digitalcontents-alarm/pages/mypage/my_page.dart'; // MyPageのインポートを忘れずに

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String newUserEmail = "";
  String newUserPassword = "";
  String newUserName = ""; // ユーザー名を追加
  String loginUserEmail = ""; // ログイン用のメールアドレス
  String loginUserPassword = ""; // ログイン用のパスワード
  String infoText = "";

  bool isLoginMode = false; // 初期状態はログインページ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'ログイン' : 'ユーザー登録'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              // メールアドレスの入力フィールド
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    if (isLoginMode) {
                      loginUserEmail = value;
                    } else {
                      newUserEmail = value;
                    }
                  });
                },
              ),
              const SizedBox(height: 8),

              // ユーザー名の入力フィールド（新たに追加）
              if (!isLoginMode) // ログインモードでない場合に表示
                TextFormField(
                  decoration: InputDecoration(labelText: "名前"),
                  onChanged: (String value) {
                    setState(() {
                      newUserName = value;
                    });
                  },
                ),
              const SizedBox(height: 8),

              // パスワードの入力フィールド
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード（６文字以上）"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    if (isLoginMode) {
                      loginUserPassword = value;
                    } else {
                      newUserPassword = value;
                    }
                  });
                },
              ),
              const SizedBox(height: 8),

              // 登録・ログインボタン
              ElevatedButton(
                onPressed: () async {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final FirebaseFirestore firestore =
                      FirebaseFirestore.instance;

                  try {
                    if (isLoginMode) {
                      // ログイン処理
                      final UserCredential result =
                          await auth.signInWithEmailAndPassword(
                        email: loginUserEmail,
                        password: loginUserPassword,
                      );
                      final User user = result.user!;

                      setState(() {
                        infoText = "ログインOK：${user.email}";
                      });

                      // ログイン後にMyPageに遷移
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyPage()),
                      );
                    } else {
                      // ユーザー登録処理
                      final UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                        email: newUserEmail,
                        password: newUserPassword,
                      );
                      final User user = result.user!;

                      // ユーザー情報をFirestoreに保存
                      await firestore.collection('users').doc(user.uid).set({
                        'email': newUserEmail, // ユーザーのメールアドレス
                        'name': newUserName, // ユーザーの名前
                      });

                      setState(() {
                        infoText = "登録OK：${user.email}";
                      });

                      // 登録後にMyPageに遷移
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyPage()),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      infoText = isLoginMode
                          ? "ログインNG：${e.toString()}"
                          : "登録NG：${e.toString()}";
                    });
                  }
                },
                child: Text(isLoginMode ? "ログイン" : "ユーザー登録"),
              ),
              const SizedBox(height: 8),

              // 情報メッセージの表示
              Text(infoText),
              const SizedBox(height: 16),

              // ログインと登録の切り替えボタン
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoginMode = !isLoginMode;
                    infoText = ""; // 切り替え時に情報メッセージをリセット
                  });
                },
                child: Text(isLoginMode ? "アカウントを作成する" : "ログインする"),
              ),

              // ログインページに戻るボタン（登録ページから戻す）
              if (!isLoginMode) // 登録画面にいる時のみ表示
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginMode = true; // ログインモードに戻す
                      infoText = ""; // 情報メッセージをリセット
                    });
                  },
                  child: Text("ログインページに戻る"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
