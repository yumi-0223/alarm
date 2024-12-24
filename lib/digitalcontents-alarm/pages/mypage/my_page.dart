import 'package:flutter/material.dart';
import '../group/alarm_group1.dart';
import '../group/alarm_group2.dart';
import '../group/alarm_group3.dart';
import '../setting/setting_page.dart';
import 'alarm_Screen.dart';
import 'open_camera.dart';
import 'alarm_triggered_page.dart';
import 'todo.dart';
import 'dart:async';
// import 'package:image_picker/image_picker.dart'; // image_pickerをインポート
import 'package:audioplayers/audioplayers.dart'; // 音楽再生用
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // 通知用

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // Todoリスト（各Todoのタイトル、アラーム時刻、アラーム状態を保持）
  List<Todo> todoList = [
    Todo(title: "目覚まし1"),
    Todo(title: "目覚まし2"),
    Todo(title: "目覚まし3"),
  ];

  DateTime currentTime = DateTime.now();
  bool _isAlarmTriggered = false;
  // final ImagePicker _picker = ImagePicker(); // ImagePickerのインスタンスを作成

  // // カメラを起動する関数
  // Future<void> _openCamera() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     print('カメラで撮影された画像: ${image.path}');
  //     // 撮影された画像の処理をここで行う
  //   } else {
  //     print('カメラがキャンセルされました');
  //   }
  // }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
  final AudioPlayer audioPlayer = AudioPlayer(); // 音楽再生用

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    // 1秒ごとに時刻を更新
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
      _checkAlarmTime();
    });
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // 通知アイコンを設定
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  void _onNotificationResponse(NotificationResponse notificationResponse) {
    _showAlarmScreen(); // アラーム画面を表示
  }

  void _showAlarmScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlarmTriggeredPage(audioPlayer: audioPlayer)),
    );
  }

  // 各Todoのアラーム時刻を確認
  void _checkAlarmTime() {
    for (var todo in todoList) {
      if (todo.alarmTime != null && todo.isAlarmOn) {
        final now = TimeOfDay.now();
        if (now.hour == todo.alarmTime!.hour &&
            now.minute == todo.alarmTime!.minute) {
          // アラーム音を再生
          _playAlarmSound();

          // アラーム画面に遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmTriggeredPage(audioPlayer: audioPlayer),
            ),
          );

          todo.isAlarmOn = false; // アラームを一時停止
          _isAlarmTriggered = true;
          break;
        }
      }
    }
  }

  // 通知を表示
  void _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'アラーム',
      'アラームが鳴っています！',
      platformDetails,
    );
  }

  // アラーム音を再生
  void _playAlarmSound() async {
    await audioPlayer.play(
      AssetSource('alarm.mp3'), // `assets/alarm.mp3` にアラーム音を配置
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'マイページ | ${currentTime.hour}:${currentTime.minute}:${currentTime.second}',
        ),
      ),
      body: Stack(
        children: [
          // Todoリスト
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    final todo = todoList[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // アラームタイトル
                            Text(
                              todo.title,
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 20),

                            // アラーム時刻（設定されている場合のみ表示）
                            if (todo.alarmTime != null)
                              Text(
                                "${todo.alarmTime!.hour.toString().padLeft(2, '0')}:${todo.alarmTime!.minute.toString().padLeft(2, '0')}",
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        const Color.fromARGB(255, 70, 70, 70)),
                              ),

                            const SizedBox(width: 10), // 時刻とスイッチの間隔

                            // スイッチ（アラームON/OFF）
                            if (todo.alarmTime != null)
                              Switch(
                                value: todo.isAlarmOn,
                                onChanged: (value) {
                                  setState(() {
                                    todo.isAlarmOn = value;
                                  });
                                },
                              ),

                            const SizedBox(width: 10), // スイッチとボタンの間隔

                            // セットボタン
                            ElevatedButton(
                              onPressed: () async {
                                final selectedTime =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => AlarmScreen()),
                                );
                                if (selectedTime != null) {
                                  setState(() {
                                    todo.alarmTime = selectedTime;
                                    todo.isAlarmOn = true;
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
              ),
              // カメラボタンやメッセージ表示部分
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height *
                        0.3), // グループタブとの間隔調整
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    // カメラアイコンボタン
                    // ElevatedButton.icon(
                    //    onPressed: _openCamera, // ボタンが押されたときにカメラを起動
                    //   icon: Icon(Icons.camera_alt), // カメラアイコン
                    //   label: Text('カメラを起動'), // ボタンのラベル
                    // ),
                  ],
                ),
              ),
            ],
          ),
          // グループ選択ボタン
          Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height * 7 / 10,
            child: Row(
              children: [
                _buildGroupButton(context, "設定", SettingPage()),
                _buildGroupButton(context, "グループ1", AlarmGroup1()),
                _buildGroupButton(context, "グループ2", AlarmGroup2()),
                _buildGroupButton(context, "グループ3", AlarmGroup3()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupButton(BuildContext context, String label, Widget page) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.height * 1 / 5,
      child: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page),
          );
          if (newListText != null) {
            setState(() {
              todoList.add(newListText);
            });
          }
        },
        child: Text(label),
      ),
    );
  }
}
