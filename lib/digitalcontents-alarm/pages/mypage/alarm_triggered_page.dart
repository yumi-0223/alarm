import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AlarmTriggeredPage extends StatelessWidget {
  final AudioPlayer audioPlayer; // AudioPlayerインスタンスを受け取る

  AlarmTriggeredPage({required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム！'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            // アラーム音を停止
            await audioPlayer.stop();
            Navigator.pop(context, false); // アラーム状態をリセット
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'アラーム時刻がきました！',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // アラーム音を停止
                await audioPlayer.stop();
                Navigator.pop(context, false); // アラーム状態をリセット
              },
              child: Text(
                '停止',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
