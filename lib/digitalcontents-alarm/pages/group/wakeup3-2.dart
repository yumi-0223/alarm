import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../group/alarm_group3.dart'; // 対象ページのインポートを追加

class Wakeup3_2 extends StatelessWidget {
  final String userId;

  const Wakeup3_2({required this.userId});

  Future<void> _updateAlarmTime() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // 現在時刻の1分後を計算
      final currentTime = DateTime.now();
      final updatedTime = currentTime.add(Duration(minutes: 1));
      final formattedTime =
          "${updatedTime.hour}:${updatedTime.minute.toString().padLeft(2, '0')} ${updatedTime.hour < 12 ? 'AM' : 'PM'}";

      // Firebaseの更新
      await firestore.collection('users').doc(userId).update({
        '目覚まし1Time': formattedTime, // 新しい時刻
        '目覚まし1Set': true, // 目覚ましをオン
      });
    } catch (e) {
      print('目覚まし時刻の更新中にエラーが発生しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '本当にこのユーザーの目覚まし時刻を変更しますか？',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: screenWidth / 4,
                height: screenHeight / 8,
                child: ElevatedButton(
                  onPressed: () async {
                    await _updateAlarmTime(); // 目覚まし時刻を更新
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlarmGroup3(), // ページに遷移
                      ),
                    );
                  },
                  child: Text('はい', style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(
                width: screenWidth / 4,
                height: screenHeight / 8,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('いいえ', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
