import 'package:alarm/digitalcontents-alarm/pages/group/alarm_group1.dart';
import 'package:alarm/digitalcontents-alarm/pages/group/alarm_group2.dart';
import 'package:flutter/material.dart';
import '../setting/setting_page.dart';
import 'package:alarm/digitalcontents-alarm/pages/group/wakeup3.dart';
import '../mypage/my_page.dart';

class AlarmGroup3 extends StatefulWidget {
  @override
  _AlarmGroup3State createState() => _AlarmGroup3State();
}

class _AlarmGroup3State extends State<AlarmGroup3> {
  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('グループ３'),
      ),
      body: Stack(
        children: [
          // グループ選択ボタン
          Positioned(
            left: screenWidth * 0, // 位置
            top: screenHeight * 7 / 10, // 位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () async {
                  final newListText = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return SettingPage();
                    }),
                  );
                },
                child: const Text("設定"),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 1 / 4, // 位置
            top: screenHeight * 7 / 10, // 位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () async {
                  final newListText = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return AlarmGroup1();
                    }),
                  );
                },
                child: const Text("グループ1"),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 2 / 4, // 位置
            top: screenHeight * 7 / 10, // 位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () async {
                  final newListText = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return AlarmGroup2();
                    }),
                  );
                },
                child: const Text("グループ2"),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 3 / 4, // 位置
            top: screenHeight * 7 / 10, // 位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () async {
                  final newListText = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return AlarmGroup3();
                    }),
                  );
                },
                child: const Text("グループ3"),
              ),
            ),
          ),
          Stack(
            children: List.generate(4, (index) {
              return Positioned(
                left: screenWidth / 10,
                top: screenHeight * (1 + 1.5 * index) / 10, // 間隔を調整
                child: Text(
                  '名前${index + 1}', // 名前1, 名前2, ...
                ),
              );
            }),
          ),

          Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width * 8 / 10,
                top: MediaQuery.of(context).size.height * 1 / 10,
                child: Stack(
                  alignment: Alignment.center, // 中央にアイコンを配置
                  children: [
                    FloatingActionButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Wakeup3(), // Wakeup1ページに遷移
                        ),
                      );
                    }),
                    Icon(
                      Icons.alarm, // ボタンの上に表示するアイコン
                      size: 24, // アイコンのサイズ
                    ),
                  ],
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 8 / 10,
                top: MediaQuery.of(context).size.height * 2.5 / 10,
                child: Stack(
                  alignment: Alignment.center, // 中央にアイコンを配置
                  children: [
                    FloatingActionButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Wakeup3(), // Wakeup1ページに遷移
                        ),
                      );
                    }),
                    Icon(
                      Icons.alarm, // ボタンの上に表示するアイコン
                      size: 24, // アイコンのサイズ
                    ),
                  ],
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 8 / 10,
                top: MediaQuery.of(context).size.height * 4 / 10,
                child: Stack(
                  alignment: Alignment.center, // 中央にアイコンを配置
                  children: [
                    FloatingActionButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Wakeup3(), // Wakeup1ページに遷移
                        ),
                      );
                    }),
                    Icon(
                      Icons.alarm, // ボタンの上に表示するアイコン
                      size: 24, // アイコンのサイズ
                    ),
                  ],
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 8 / 10,
                top: MediaQuery.of(context).size.height * 5.5 / 10,
                child: Stack(
                  alignment: Alignment.center, // 中央にアイコンを配置
                  children: [
                    FloatingActionButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Wakeup3(), // Wakeup1ページに遷移
                        ),
                      );
                    }),
                    Icon(
                      Icons.alarm, // ボタンの上に表示するアイコン
                      size: 24, // アイコンのサイズ
                    ),
                  ],
                ),
              ),
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
        ],
      ),
    );
  }
}
