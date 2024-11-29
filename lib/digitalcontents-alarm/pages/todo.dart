import 'package:flutter/material.dart';

class Todo {
  String title;
  TimeOfDay? alarmTime; // アラーム時刻
  bool isAlarmOn; // アラームON/OFF状態

  Todo({
    required this.title,
    this.alarmTime,
    this.isAlarmOn = false,
  });
}
