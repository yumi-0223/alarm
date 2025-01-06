import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupCreatePage extends StatefulWidget {
  @override
  _GroupCreatePageState createState() => _GroupCreatePageState();
}

class _GroupCreatePageState extends State<GroupCreatePage> {
  final TextEditingController _groupIDController = TextEditingController();
  final TextEditingController _groupPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _groupIDController.dispose();
    _groupPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final String groupID = _groupIDController.text.trim();
    final String groupPassword = _groupPasswordController.text.trim();

    if (groupID.isEmpty || groupPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('グループIDとパスワードを入力してください')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('ユーザーがログインしていません');
      }

      // Firestoreにグループを保存
      final groupRef =
          FirebaseFirestore.instance.collection('groups').doc(groupID);

      // グループが既に存在している場合はエラー
      final groupDoc = await groupRef.get();
      if (groupDoc.exists) {
        throw Exception('このグループIDは既に存在しています');
      }

      await groupRef.set({
        'password': groupPassword,
        'members': [user.uid], // 初期メンバーとして作成者を追加
        'alarms': {}, // 空のアラームデータ
      });

      // ユーザー情報にグループを追加
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.set({
        'groups': FieldValue.arrayUnion([groupID]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('グループを作成しました')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("グループ作成")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupIDController,
              decoration: InputDecoration(labelText: 'グループID'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _groupPasswordController,
              decoration: InputDecoration(labelText: 'グループパスワード'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text("作成"),
            ),
          ],
        ),
      ),
    );
  }
}
