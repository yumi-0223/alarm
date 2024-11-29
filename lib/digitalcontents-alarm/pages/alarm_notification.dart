/*import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  // Timezoneの初期化
  tz.initializeTimeZones();

  // 通知プラグインの初期化
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await notificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleAlarm(DateTime alarmTime) async {
  final notificationDetails = NotificationDetails(
  android: const AndroidNotificationDetails(
    channelId: 'alarm_channel', // チャンネルID
    channelName: 'Alarm Notifications', // チャンネル名
    channelDescription: 'Channel for alarm notifications', // 説明
    importance: Importance.max,
    priority: Priority.high,
  ),
);



  await notificationsPlugin.zonedSchedule(
    0,
    'アラーム',
    '起きる時間です！',
    tz.TZDateTime.from(alarmTime, tz.local), // DateTime を TZDateTime に変換
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // APIの最新仕様に変更
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
*/
