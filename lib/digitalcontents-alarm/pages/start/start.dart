/*ひなたちゃんここで書いてね*/
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PermissionExample(),
    );
  }
}

class PermissionExample extends StatelessWidget {
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied) {
      // 権限をリクエスト
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      print("通知が許可されました");
    } else {
      print("通知が許可されませんでした");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Permission Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            requestNotificationPermission();
          },
          child: Text('通知の許可をリクエスト'),
        ),
      ),
    );
  }
}
