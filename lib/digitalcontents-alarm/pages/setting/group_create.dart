import 'package:flutter/material.dart';

class GroupCreatePage extends StatefulWidget {
  @override
  _GroupCreatePageState createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {
  // TextEditingControllerを定義してテキストの内容を管理
  final TextEditingController _groupIDController = TextEditingController();
  final TextEditingController _groupPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // メモリリークを防ぐためにコントローラーを解放
    _groupIDController.dispose();
    _groupPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("グループ作成")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupIDController, // グループID用コントローラー
              decoration: InputDecoration(labelText: 'グループID'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _groupPasswordController, // グループパスワード用コントローラー
              decoration: InputDecoration(labelText: 'グループパスワード'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 入力された内容を戻す
                Navigator.of(context).pop({
                  'groupID': _groupIDController.text,
                  'groupPassword': _groupPasswordController.text,
                });
              },
              child: Text("作成"),
            ),
          ],
        ),
      ),
    );
  }
}
