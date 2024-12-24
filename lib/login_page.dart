import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";
  // 画面表示を切り替えるフラグ
  bool isLoginMode = true;

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
              // メールアドレスの入力フィールド（ログイン・登録両方共通）
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
              // パスワードの入力フィールド（ログイン・登録両方共通）
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
              // ログイン・登録ボタン
              ElevatedButton(
                onPressed: () async {
                  final FirebaseAuth auth = FirebaseAuth.instance;
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
                    } else {
                      // ユーザー登録処理
                      final UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                        email: newUserEmail,
                        password: newUserPassword,
                      );
                      final User user = result.user!;
                      setState(() {
                        infoText = "登録OK：${user.email}";
                      });
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
            ],
          ),
        ),
      ),
    );
  }
}
