import 'package:flutter/material.dart';


class AlarmTriggeredPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム！'),
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
