import 'package:alarm/digitalcontents-alarm/pages/group/alarm_group2.dart';
import 'package:flutter/material.dart';
import 'wakeup2-2.dart';

class Wakeup1_1 extends StatelessWidget {
  final String userId;
  final String alarmTime;

  const Wakeup1_1({required this.userId, required this.alarmTime});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: screenWidth * 0.1,
            top: screenHeight * 0.3,
            child: Container(
              width: screenWidth * 0.8,
              alignment: Alignment.center,
              child: Text(
                'ユーザーの目覚まし時刻: $alarmTime\n起こしますか？',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 1 / 5,
            top: screenHeight * 6 / 10,
            child: SizedBox(
              width: screenWidth / 4,
              height: screenHeight * 1 / 5,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Wakeup2_2(
                        userId: userId, // ユーザーIDを次のページに渡す
                      ),
                    ),
                  );
                },
                child: const Text("はい"),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 3 / 5,
            top: screenHeight * 6 / 10,
            child: SizedBox(
              width: screenWidth / 4,
              height: screenHeight * 1 / 5,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("いいえ"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
