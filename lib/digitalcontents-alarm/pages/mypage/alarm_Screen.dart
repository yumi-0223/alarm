import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AlarmSettingPage(
        alarmLabel: 'alarm1', // 動的なラベルを指定
        initialTime: null,
      ),
    );
  }
}

class AlarmSettingPage extends StatefulWidget {
  final String alarmLabel; // 例: 'alarm1', 'alarm2'
  final TimeOfDay? initialTime;

  const AlarmSettingPage({
    Key? key,
    required this.alarmLabel,
    this.initialTime,
  }) : super(key: key);

  @override
  _AlarmSettingPageState createState() => _AlarmSettingPageState();
}

class _AlarmSettingPageState extends State<AlarmSettingPage> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  // Firebaseに目覚ましデータを保存
  Future<void> saveAlarmToFirebase(String alarmLabel, TimeOfDay time) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser; // 現在のログインユーザーを取得
      if (user == null) {
        throw Exception('ユーザーがログインしていません');
      }

      final String userId = user.uid;

      // 動的にデータを生成
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        '${alarmLabel}Time': time.format(context), // 例: 'alarm1Time'
        '${alarmLabel}Set': true, // 有効化
      }, SetOptions(merge: true)); // 既存データを保持しつつ更新

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('目覚まし時刻を保存しました！')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム設定 (${widget.alarmLabel})'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedTime != null
                  ? "設定時刻: ${selectedTime!.format(context)}"
                  : "時刻が未設定です",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                }
              },
              child: const Text(
                '時刻を選択',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedTime != null) {
                  saveAlarmToFirebase(widget.alarmLabel, selectedTime!);
                  Navigator.pop(context, selectedTime);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('時刻を選択してください')),
                  );
                }
              },
              child: const Text(
                '保存',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
