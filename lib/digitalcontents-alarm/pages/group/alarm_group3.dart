import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../setting/setting_page.dart';
import '../mypage/my_page.dart'; // MyPageのインポートを追加
import 'package:alarm/digitalcontents-alarm/pages/group/wakeup1-1.dart';

class AlarmGroup3 extends StatefulWidget {
  @override
  _AlarmGroup3State createState() => _AlarmGroup3State();
}

class _AlarmGroup3State extends State<AlarmGroup3> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? groupId;
  Map<String, dynamic> groupData = {};
  Map<String, String> userNames = {};
  Map<String, String> memberAlarmTimes = {};
  Map<String, String> wakeStatuses = {}; // メンバーの起床状態
  String? alarmTime;

  @override
  void initState() {
    super.initState();
    _fetchGroupData();
    _fetchAlarmTime();
  }

  Future<void> _fetchGroupData() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('ログインユーザーが見つかりません');

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      if (userData == null || userData['groups'] == null) {
        throw Exception('ユーザーのグループ情報が見つかりません');
      }

      final List<dynamic> userGroups = userData['groups'];
      final String selectedGroupId = userGroups[2];

      final groupDoc =
          await firestore.collection('groups').doc(selectedGroupId).get();
      if (!groupDoc.exists) throw Exception('グループ情報が見つかりません');

      setState(() {
        groupId = selectedGroupId;
        groupData = groupDoc.data() as Map<String, dynamic>;
      });

      await _fetchUserNamesAndAlarmTimes(groupData['members'] as List<dynamic>);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e')),
      );
    }
  }

  Future<void> _fetchUserNamesAndAlarmTimes(List<dynamic> memberIds) async {
    try {
      for (String userId in memberIds) {
        if (!userNames.containsKey(userId)) {
          final userDoc = await firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            final userData = userDoc.data();
            if (userData != null) {
              setState(() {
                userNames[userId] = userData['name'] ?? '名前未設定';
                memberAlarmTimes[userId] =
                    userData['目覚まし1Time'] ?? '未設定'; // 目覚まし時刻
                wakeStatuses[userId] = userData['wakeStatus'] ?? '不明'; // 起床状態
              });
            }
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('データ取得エラー: $e')),
      );
    }
  }

  Future<void> _fetchAlarmTime() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('ログインユーザーが見つかりません');

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      if (userData == null) throw Exception('ユーザー情報が見つかりません');

      setState(() {
        alarmTime = userData['目覚まし1Time'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('目覚まし時間取得エラー: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (groupId == null || groupData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('グループ3'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final members = groupData['members'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('グループ3'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                alarmTime != null ? '起床予定時刻: $alarmTime' : '目覚まし時間を取得中...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ...List.generate(members.length, (index) {
                final memberId = members[index];
                final memberName = userNames[memberId] ?? '名前を取得中...';
                final memberAlarmTime = memberAlarmTimes[memberId] ?? '未設定';
                final wakeStatus = wakeStatuses[memberId] ?? '不明';

                bool showWakeButton = false;

                if (memberAlarmTime != '未設定') {
                  final alarmDateTime = _parseAlarmTime(memberAlarmTime);
                  if (alarmDateTime != null &&
                      alarmDateTime.isBefore(DateTime.now()) &&
                      wakeStatus == '起きてない') {
                    showWakeButton = true;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              memberName,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '状態: $wakeStatus', // 起床状態を表示
                              style: TextStyle(
                                fontSize: 14,
                                color: wakeStatus == '起きてる'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          '目覚まし: $memberAlarmTime',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      if (showWakeButton)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Wakeup1_1(
                                  userId: memberId, // ユーザーIDを渡す
                                  alarmTime: memberAlarmTime, // 現在の目覚まし時刻を渡す
                                ),
                              ),
                            );
                          },
                          child: Text('起こす'),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20), // ボタン位置調整
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPage()),
            );
          },
          label: Text(
            'マイページ',
            style: TextStyle(fontSize: 16),
          ),
          icon: Icon(Icons.home),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // ボタンを中央下に配置
    );
  }

  DateTime? _parseAlarmTime(String alarmTime) {
    try {
      final now = DateTime.now();
      final timeParts = alarmTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1].split(' ')[0]);
      final isPM = alarmTime.toLowerCase().contains('pm');
      return DateTime(
        now.year,
        now.month,
        now.day,
        isPM ? hour + 12 : hour,
        minute,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _sendWakeNotification(String memberId) async {
    try {
      await firestore.collection('users').doc(memberId).update({
        'wakeStatus': '起きてる',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('起こす通知を送信しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('通知送信エラー: $e')),
      );
    }
  }
}
