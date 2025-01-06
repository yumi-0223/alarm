import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupJoinPage extends StatefulWidget {
  @override
  _GroupJoinPageState createState() => _GroupJoinPageState();
}

class _GroupJoinPageState extends State<GroupJoinPage> {
  final TextEditingController _groupIDController = TextEditingController();
  final TextEditingController _groupPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _groupIDController.dispose();
    _groupPasswordController.dispose();
    super.dispose();
  }

  Future<void> _joinGroup() async {
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

      final groupRef =
          FirebaseFirestore.instance.collection('groups').doc(groupID);
      final groupDoc = await groupRef.get();

      if (!groupDoc.exists) {
        throw Exception('指定されたグループは存在しません');
      }

      final groupData = groupDoc.data()!;
      if (groupData['password'] != groupPassword) {
        throw Exception('パスワードが正しくありません');
      }

      if (groupData['members'].length >= 4) {
        throw Exception('このグループはメンバーが満員です');
      }

      // グループにユーザーを追加
      await groupRef.update({
        'members': FieldValue.arrayUnion([user.uid]),
      });

      // ユーザー情報にグループを追加
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.set({
        'groups': FieldValue.arrayUnion([groupID]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('グループに参加しました')),
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
      appBar: AppBar(title: Text("グループに入る")),
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
              onPressed: _joinGroup,
              child: Text("グループに入る"),
            ),
          ],
        ),
      ),
    );
  }
}
