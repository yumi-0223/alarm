import 'package:flutter/material.dart';
import 'group/alarm_group1.dart';
import 'group/alarm_group2.dart';
import 'group/alarm_group3.dart';
import 'setting/setting_page.dart';
import 'alarm_Screen.dart';
import 'dart:async';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // グループページ
  List<String> todoList = ["目覚まし1", "目覚まし2", "目覚まし3"];
  DateTime currentTime = DateTime.now();

  //現在時刻の変数
  @override
  void initState() {
    super.initState();
    // 1秒ごとに時刻を更新
    Timer.periodic(Duration(seconds: 1), (timer) {
      // 時刻を更新してsetStateで再描画
      setState(() {
        currentTime = DateTime.now(); // 時刻更新
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: const Text('マイページ'),
      ),
      // データを元にListViewを作成
      body: Stack(
        children: [
          //Todoリストを表示するListView.builder
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // カード内に余白を追加
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
                      children: [
                        Text(
                          todoList[index],
                          style: TextStyle(fontSize: 18), // タイトルのテキスト
                        ),
                        const SizedBox(width: 20), // テキストとボタンの間隔
                        ElevatedButton(
                          onPressed: () async {
                            // 「セット」ボタンが押された時、AlarmScreenに遷移
                            final selectedTime = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => AlarmScreen()),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                todoList[index] = 'アラーム時刻: ${selectedTime.format(context)}'; // 時刻を表示
                              });
                            }
                          },
                          child: const Text('セット'),
                        ),
                                    
                      ],
                    ),
                  ),
                );
              },
            ),
          )
          ,

          Align(
            alignment: Alignment(0, 0.2), // 中央揃え（x方向: 0, y方向: -0.5）
            child: Row(
              mainAxisSize: MainAxisSize.min, // 必要最小限の高さに
              mainAxisAlignment: MainAxisAlignment.center, // 横方向の中央揃え
          children: [
            Container(
              width: 100, // 幅を固定
              height: 50, // 高さを固定
              alignment: Alignment.center, // 中央揃え
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 67, 67, 67), width: 1), // 枠線
                color: const Color.fromARGB(255, 212, 212, 212),
              ),
              child: Text(
                "起きてる",
                style: TextStyle(fontSize: 16),
              ),
            ),
            //const SizedBox(width: 20), // テキスト間の間隔
            Container(
              width: 100, // 幅を固定
              height: 50, // 高さを固定
              alignment: Alignment.center, // 中央揃え
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 67, 67, 67), width: 1), // 枠線
                color: const Color.fromARGB(255, 212, 212, 212),
              ),
              child: Text(
                "起きてない",
                style: TextStyle(fontSize: 16),
              ),
            ),
              ],
            ),
          ),
          //グループ選択ボタン
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
                  if (newListText != null) {
                    setState(() {
                      todoList.add(newListText);
                    });
                  }
                },
                child: const Text("設定"), // 修正: const を追加
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 1 / 4, //位置
            top: screenHeight * 7 / 10, //位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () async {
                  // "push"で新規画面に遷移
                  // リスト追加画面から渡される値を受け取る
                  final newListText = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      // 遷移先の画面としてリスト追加画面を指定
                      return AlarmGroup1();
                    }),
                  );
                  if (newListText != null) {
                    // キャンセルした場合は newListText が null となるので注意
                    setState(() {
                      // リスト追加
                      todoList.add(newListText);
                    });
                  }
                },
                child: const Text("グループ1"),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 2 / 4, //位置
            top: screenHeight * 7 / 10, //位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () async {
                  // "push"で新規画面に遷移
                  // リスト追加画面から渡される値を受け取る
                  final newListText = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      // 遷移先の画面としてリスト追加画面を指定
                      return AlarmGroup2();
                    }),
                  );
                  if (newListText != null) {
                    // キャンセルした場合は newListText が null となるので注意
                    setState(() {
                      // リスト追加
                      todoList.add(newListText);
                    });
                  }
                },
                child: const Text("グループ2"),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 3 / 4, //位置
            top: screenHeight * 7 / 10, //位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () async {
                  // "push"で新規画面に遷移
                  // リスト追加画面から渡される値を受け取る
                  final newListText = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      // 遷移先の画面としてリスト追加画面を指定
                      return AlarmGroup3();
                    }),
                  );
                  if (newListText != null) {
                    // キャンセルした場合は newListText が null となるので注意
                    setState(() {
                      // リスト追加
                      todoList.add(newListText);
                    });
                  }
                },
                child: const Text("グループ3"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
