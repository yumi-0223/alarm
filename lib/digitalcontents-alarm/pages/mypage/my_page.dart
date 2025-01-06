import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../group/alarm_group1.dart';
import '../group/alarm_group2.dart';
import '../group/alarm_group3.dart';
import '../setting/setting_page.dart';
import 'alarm_Screen.dart';
import 'todo.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:alarm/digitalcontents-alarm/pages/mypage/alarm_triggered_page.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Todo> todoList = [
    Todo(title: "目覚まし1"),
    Todo(title: "目覚まし2"),
    Todo(title: "目覚まし3"),
  ];

  DateTime currentTime = DateTime.now();
  String wakeStatus = "起きてる"; // 初期状態

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer audioPlayer = AudioPlayer();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
      _checkAlarmTime();
    });
    _fetchWakeStatus(); // 起床状態を初期取得
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  void _onNotificationResponse(NotificationResponse notificationResponse) {
    _showAlarmScreen();
  }

  void _showAlarmScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AlarmTriggeredPage(audioPlayer: audioPlayer)),
    );
  }

  void _checkAlarmTime() {
    for (var todo in todoList) {
      if (todo.alarmTime != null && todo.isAlarmOn) {
        final now = TimeOfDay.now();
        if (now.hour == todo.alarmTime!.hour &&
            now.minute == todo.alarmTime!.minute) {
          _playAlarmSound();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AlarmTriggeredPage(audioPlayer: audioPlayer),
            ),
          );

          todo.isAlarmOn = false;
          break;
        }
      }
    }
  }

  void _playAlarmSound() async {
    await audioPlayer.play(
      AssetSource('alarm.mp3'),
    );
  }

  Future<void> _fetchWakeStatus() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('ログインしているユーザーが見つかりません');

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();

      if (userData != null && userData['wakeStatus'] != null) {
        setState(() {
          wakeStatus = userData['wakeStatus'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('起床状態の取得エラー: $e')),
      );
    }
  }

  Future<void> _updateWakeStatus(String status) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('ログインしているユーザーが見つかりません');

      await firestore.collection('users').doc(user.uid).set(
        {'wakeStatus': status},
        SetOptions(merge: true),
      );

      setState(() {
        wakeStatus = status;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('起床状態を更新しました: $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('起床状態の更新エラー: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'マイページ | ${currentTime.hour}:${currentTime.minute}:${currentTime.second}',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          todo.title,
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 20),
                        if (todo.alarmTime != null)
                          Text(
                            "${todo.alarmTime!.hour.toString().padLeft(2, '0')}:${todo.alarmTime!.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(fontSize: 20),
                          ),
                        const SizedBox(width: 10),
                        if (todo.alarmTime != null)
                          Switch(
                            value: todo.isAlarmOn,
                            onChanged: (value) {
                              setState(() {
                                todo.isAlarmOn = value;
                              });
                            },
                          ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final updatedTime =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AlarmSettingPage(
                                  alarmLabel: todo.title,
                                  initialTime: todo.alarmTime,
                                ),
                              ),
                            );

                            if (updatedTime != null) {
                              setState(() {
                                todo.alarmTime = updatedTime;
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

          // 起床状態選択ボタン
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        wakeStatus == "起きてる" ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => _updateWakeStatus("起きてる"),
                  child: Text("起きてる"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        wakeStatus == "起きてない" ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _updateWakeStatus("起きてない"),
                  child: Text("起きてない"),
                ),
              ],
            ),
          ),

          // グループ選択ボタン
          Row(
            children: [
              _buildGroupButton(context, "設定", SettingPage()),
              _buildGroupButton(context, "グループ1", AlarmGroup1()),
              _buildGroupButton(context, "グループ2", AlarmGroup2()),
              _buildGroupButton(context, "グループ3", AlarmGroup3()),
            ],
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(label),
      ),
    );
  }
}
