import 'package:flutter/material.dart';
import 'group/alarm_group1.dart';
import 'group/alarm_group2.dart';
import 'group/alarm_group3.dart';
import 'setting/setting_page.dart';
import 'alarm_Screen.dart';
import 'open_camera.dart';
import 'alarm_triggered_page.dart';
import 'dart:async';
//import 'package:image_picker/image_picker.dart';  // image_pickerをインポート


class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}



class _MyPageState extends State<MyPage> {
  // グループページ
  List<String> todoList = ["目覚まし1", "目覚まし2", "目覚まし3"];
  DateTime currentTime = DateTime.now();
  TimeOfDay? alarmTime; // アラーム時刻を保持

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
      _checkAlarmTime(); 
    });
  }

  // アラーム時刻と現在時刻を比較して一致した場合に画面遷移
  void _checkAlarmTime() {
    if (alarmTime != null) {
      final now = TimeOfDay.now();
      if (now.hour == alarmTime!.hour && now.minute == alarmTime!.minute) {
        // アラーム時刻と一致した場合に画面遷移
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlarmTriggeredPage()),
        );
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('マイページ | ${currentTime.hour}:${currentTime.minute}:${currentTime.second}'),
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
                                alarmTime = selectedTime; // アラーム時刻を保存
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

          Column(
            mainAxisAlignment: MainAxisAlignment.center, // 縦方向に中央揃え
            children: <Widget>[
              // 起きてる・起きてないの表示
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 横並びの中央揃え
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      color: const Color.fromARGB(255, 211, 211, 211),
                    ),
                    child: Text(
                      "起きてる",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      color: const Color.fromARGB(255, 211, 211, 211),
                    ),
                    child: Text(
                      "起きてない",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              // カメラボタン
            ElevatedButton.icon(
            onPressed: () {
              // カメラ起動の処理をコメントアウト
              print("カメラ起動ボタンが押されました");
            },
            icon: Container(
              padding: EdgeInsets.all(5), // アイコンの周りに余白を追加
              decoration: BoxDecoration(
                shape: BoxShape.circle, // 丸い枠
                border: Border.all(color: Colors.white, width: 1), // 白い枠線
              ),
              child: Icon(Icons.camera_alt, color: Colors.white), // アイコンを白色に
            ),
            label: Text('カメラを起動'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0), // 背景色
              foregroundColor: Colors.white, // 文字色
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // 四角形
              ),
              minimumSize: Size(234, 50), // 横幅200、高さ50
            ),
            ),
            ],
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


