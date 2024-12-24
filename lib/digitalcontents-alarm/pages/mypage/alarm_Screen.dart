import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
        alarmLabel: '目覚まし1',
        initialTime: null,
      ),
    );
  }
}

class AlarmSettingPage extends StatefulWidget {
  final String alarmLabel;
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

  // Firebaseに目覚ましデータを保存（常に上書き）
  Future<void> saveAlarmToFirebase(String alarmLabel, TimeOfDay time) async {
    try {
      // ユーザID（ここでは仮に「userID」として扱っています。実際のユーザIDを使ってください）
      String userId = "userID"; // ここを適切なユーザIDに変更してください

      // ユーザのデータをusersコレクションに保存
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': 'user@example.com', // 仮のメールアドレス、実際のものを使用
        'username': 'User Name', // ユーザー名
        'alarm1Time': selectedTime?.format(context), // 目覚まし1の時刻
        'alarm1Set': true, // 目覚まし1の設定有無
        'alarm2Time': '09:00', // 目覚まし2の時刻（デフォルト）
        'alarm2Set': false, // 目覚まし2の設定有無（デフォルト）
        'alarm3Time': '10:00', // 目覚まし3の時刻（デフォルト）
        'alarm3Set': false, // 目覚まし3の設定有無（デフォルト）
      }, SetOptions(merge: true)); // 既存のデータに上書きしないようにmergeを使う

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('目覚まし時刻を保存しました！')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  // 目覚まし時刻の保存ボタンが押された時の処理
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
