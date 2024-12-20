import 'package:alarm/digitalcontents-alarm/pages/setting/group_create.dart';
import 'package:alarm/digitalcontents-alarm/pages/setting/group_join.dart';
import 'package:flutter/material.dart';
import '../group/alarm_group1.dart';
import 'name_change.dart';
import '../mypage/my_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("設定")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 縦方向に中央揃え
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NameChangePage()),
                      );
                    },
                    child: Text("名前変更"),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupCreatePage()),
                      );
                    },
                    child: Text("グループ作成"),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupJoinPage()),
                      );
                    },
                    child: Text("グループ入る"),
                  ),
                ),
              ],
            ),
          ),
          // PositionedをStack内で使用
          Positioned(
            left: screenWidth * 9 / 10,
            top: screenHeight * 0 / 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPage(),
                  ),
                );
              },
              child: Icon(
                Icons.home,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
