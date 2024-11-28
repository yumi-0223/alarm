import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  TimeOfDay selectedTime = TimeOfDay.now(); // 現在の時間をデフォルトに設定

  // 時刻選択ダイアログを表示する関数
  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked; // 時刻を更新
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム設定'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '選択した時刻: ${selectedTime.format(context)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context), // 時刻を選択
              child: Text('時刻を選択'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // アラーム設定ボタンの処理
                Navigator.pop(context, selectedTime); // 選択した時刻を戻す
                print('アラームが ${selectedTime.format(context)} に設定されました。');
              },
              child: Text('アラームを設定'),
            ),
          ],
        ),
      ),
    );
  }
}