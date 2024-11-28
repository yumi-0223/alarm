import 'package:alarm/digitalcontents-alarm/pages/group/alarm_group3.dart';
import 'package:flutter/material.dart';

class Wakeup3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // テキストを配置
          Positioned(
            left: screenWidth * 0.1, // 左余白
            top: screenHeight * 0.3, // 上余白
            child: Container(
              width: screenWidth * 0.8,
              alignment: Alignment.center, // コンテナ内でテキストを中央に配置
              child: Text(
                '本当に起こしますか？？',
                textAlign: TextAlign.center, // テキストを中央揃え
                style: TextStyle(fontSize: 25), // テキストスタイル（任意）
              ),
            ),
          ),

          Positioned(
            left: screenWidth * 1 / 5, // 位置
            top: screenHeight * 6 / 10, // 位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlarmGroup1(), // Wakeup1ページに遷移
                    ),
                  );*/
                },
                child: const Text("はい"),
              ),
            ),
          ),

          Positioned(
            left: screenWidth * 3 / 5, // 位置
            top: screenHeight * 6 / 10, // 位置
            child: SizedBox(
              width: screenWidth / 4, // 幅を設定
              height: screenHeight * 1 / 5, // 高さを設定
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlarmGroup3(), // Wakeup1ページに遷移
                    ),
                  );
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
