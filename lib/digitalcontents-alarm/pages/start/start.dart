// /*ひなたちゃんここで書いてね*/
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../mypage/my_page.dart';

// class Start extends StatelessWidget {
//   Future<void> requestNotificationPermission() async {
//     var status = await Permission.notification.status;

//     if (status.isDenied) {
//       // 権限をリクエスト
//       status = await Permission.notification.request();
//     }

//     if (status.isGranted) {
//       print("通知が許可されました");
//     } else {
//       print("通知が許可されませんでした");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _MyIDController = TextEditingController();
//     final TextEditingController _MyPasswordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: Text('スタートページ')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 requestNotificationPermission();
//               },
//               child: Text('通知の許可をリクエスト'),
//             ),
//             SizedBox(height: 20), // ボタンとテキストフィールドの間に余白
//             TextField(
//               controller: _MyIDController, // myID用コントローラー
//               decoration: InputDecoration(labelText: 'MyID'),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _MyPasswordController, // Myパスワード用コントローラー
//               decoration: InputDecoration(labelText: 'MyPassword'),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyPage()),
//                   );
//                 },
//                 child: Text("グループ入る"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
