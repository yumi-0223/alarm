import 'package:flutter/material.dart';


class AlarmTriggeredPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム！'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // ここで任意の処理を追加できます
            // 戻るときにfalseを返す
            Navigator.pop(context, false); // isAlarmTriggeredをリセット
            //Navigator.pop(context); // 戻る処理
          },
        ),
      ),
      body: Center(
        child: Text(
          'アラーム時刻がきました！',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
