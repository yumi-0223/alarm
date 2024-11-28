import 'package:flutter/material.dart';
import '../group/alarm_group1.dart';
import 'name_change.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  //final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("設定")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 縦方向に中央揃え
          children: [
            // 1つ目のボタン
            Center(
              // Centerでボタンを横方向に中央揃え
              child: ElevatedButton(
                onPressed: () {
                  // ボタン1が押された時にPage1に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NameChangePage()),
                  );
                },
                child: Text("名前変更"),
              ),
            ),
            SizedBox(height: 20), // ボタン間の間隔

            // 2つ目のボタン
            Center(
              // Centerでボタンを横方向に中央揃え
              child: ElevatedButton(
                onPressed: () {
                  // ボタン2が押された時にPage2に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                child: Text("グループ作成"),
              ),
            ),
            SizedBox(height: 20), // ボタン間の間隔

            // 3つ目のボタン
            Center(
              // Centerでボタンを横方向に中央揃え
              child: ElevatedButton(
                onPressed: () {
                  // ボタン3が押された時にPage3に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                child: Text("グループ入る"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
