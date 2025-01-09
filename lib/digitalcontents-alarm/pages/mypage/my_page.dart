import 'package:alarm/digitalcontents-alarm/pages/mypage/alarm_Screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../group/alarm_group1.dart';
import '../group/alarm_group2.dart';
import '../group/alarm_group3.dart';
import '../setting/setting_page.dart';
import 'alarm_triggered_page.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AudioPlayer audioPlayer = AudioPlayer();
  Map<String, dynamic> alarmData = {};
  String wakeStatus = "起きてない"; // 初期値は「起きてない」
  DateTime currentTime = DateTime.now();

// アラームが鳴ったことを記録するリスト
  List<String> triggeredAlarms = [];
  StreamSubscription<DocumentSnapshot>? _alarmSubscription;

  @override
  void initState() {
    super.initState();
    _listenToAlarmUpdates();
    _fetchWakeStatus();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateTime.now();
      });
      _checkAlarmTime();
    });
  }

  @override
  void dispose() {
    _alarmSubscription?.cancel();
    super.dispose();
  }

  // Firebaseのリアルタイムリスナーで目覚ましデータを監視
  void _listenToAlarmUpdates() {
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ログインユーザーが見つかりません')),
      );
      return;
    }

    _alarmSubscription = firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      final userData = snapshot.data();
      if (userData != null) {
        setState(() {
          alarmData = {
            'alarm1Time': userData['目覚まし1Time'] ?? '未設定',
            'alarm1Set': userData['目覚まし1Set'] ?? false,
            'alarm2Time': userData['目覚まし2Time'] ?? '未設定',
            'alarm2Set': userData['目覚まし2Set'] ?? false,
            'alarm3Time': userData['目覚まし3Time'] ?? '未設定',
            'alarm3Set': userData['目覚まし3Set'] ?? false,
          };
        });
      }
    });
  }

  Future<void> _fetchWakeStatus() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('ログインユーザーが見つかりません');

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();

      if (userData != null && userData['wakeStatus'] != null) {
        setState(() {
          wakeStatus = userData['wakeStatus'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('起床状態取得エラー: $e')),
      );
    }
  }

  Future<void> _updateWakeStatus(String status) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('ログインユーザーが見つかりません');

      await firestore.collection('users').doc(user.uid).update({
        'wakeStatus': status,
      });

      setState(() {
        wakeStatus = status;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('起床状態を「$status」に更新しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('起床状態更新エラー: $e')),
      );
    }
  }

  void _checkAlarmTime() {
    final now = TimeOfDay.fromDateTime(currentTime);

    for (int i = 1; i <= 3; i++) {
      if (alarmData['alarm${i}Set'] == true &&
          alarmData['alarm${i}Time'] != '未設定' &&
          !triggeredAlarms.contains('alarm$i')) {
        final alarmTime = _parseTime(alarmData['alarm${i}Time']);
        if (alarmTime.hour == now.hour && alarmTime.minute == now.minute) {
          _playAlarm();
          _showAlarmScreen();
          triggeredAlarms.add('alarm$i');
          Timer(Duration(minutes: 1), () {
            triggeredAlarms.remove('alarm$i'); // 1分後にリセット
          });
          break;
        }
      }
    }
  }

  // 時刻文字列をTimeOfDayに変換
  TimeOfDay _parseTime(String timeString) {
    try {
      final timeParts = timeString.split(":");
      final hour = int.parse(timeParts[0]);
      final minuteAndPeriod = timeParts[1].split(" ");
      final minute = int.parse(minuteAndPeriod[0]);
      final isPM = minuteAndPeriod[1] == "PM";
      return TimeOfDay(
        hour: isPM ? (hour % 12) + 12 : hour % 12,
        minute: minute,
      );
    } catch (e) {
      print('Error parsing time: $timeString');
      return TimeOfDay.now();
    }
  }

  // アラーム音を再生
  void _playAlarm() async {
    try {
      await audioPlayer.play(AssetSource('alarm.mp3'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('アラームが鳴っています！')),
      );
    } catch (e) {
      print('Error playing alarm sound: $e');
    }
  }

  // アラーム画面を表示
  void _showAlarmScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmTriggeredPage(audioPlayer: audioPlayer),
      ),
    );
  }

  Widget _buildGroupButton(BuildContext context, String label, Widget page) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.height * 1 / 5,
      child: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(label),
      ),
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
      body: alarmData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: List.generate(3, (index) {
                          int i = index + 1;
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('目覚まし$i'),
                              subtitle: Text(
                                '時刻: ${alarmData['alarm${i}Time']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: alarmData['alarm${i}Set'] ?? false,
                                    onChanged: (isOn) async {
                                      setState(() {
                                        alarmData['alarm${i}Set'] = isOn;
                                      });
                                      await firestore
                                          .collection('users')
                                          .doc(auth.currentUser!.uid)
                                          .update({'目覚まし${i}Set': isOn});
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.settings),
                                    onPressed: () async {
                                      final newTime =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AlarmSettingPage(
                                            alarmLabel: '目覚まし$i',
                                            initialTime: alarmData[
                                                        'alarm${i}Time'] !=
                                                    '未設定'
                                                ? _parseTime(
                                                    alarmData['alarm${i}Time'])
                                                : null,
                                          ),
                                        ),
                                      );
                                      if (newTime != null) {
                                        setState(() {
                                          alarmData['alarm${i}Time'] =
                                              newTime.format(context);
                                        });
                                        await firestore
                                            .collection('users')
                                            .doc(auth.currentUser!.uid)
                                            .update({
                                          '目覚まし${i}Time':
                                              newTime.format(context)
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.3),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => _updateWakeStatus("起きてる"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: wakeStatus == "起きてる"
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                child: Text("起きてる"),
                              ),
                              ElevatedButton(
                                onPressed: () => _updateWakeStatus("起きてない"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: wakeStatus == "起きてない"
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                child: Text("起きてない"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
}
