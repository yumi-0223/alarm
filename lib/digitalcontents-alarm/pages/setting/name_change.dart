import 'package:flutter/material.dart';
import '../group/alarm_group1.dart';

class NameChangePage extends StatefulWidget {
  @override
  _NameChangePageState createState() => _NameChangePageState();
}

class _NameChangePageState extends State<NameChangePage> {
  // TextEditingControllerを定義してテキストの内容を管理
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("設定")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 名前変更用のテキストフィールド
            TextField(
              controller: _controller, // _controllerで管理
              decoration: InputDecoration(labelText: '変更後の名前'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 入力された内容を戻す
                Navigator.of(context).pop(_controller.text);
              },
              child: Text("保存"),
            ),
          ],
        ),
      ),
    );
  }

// @override
  // void dispose() {
  //   // メモリリークを防ぐために_controllerを解放
  //   _controller.dispose();
  //   super.dispose();
  // }
}
