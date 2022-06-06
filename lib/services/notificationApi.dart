import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi{
  static  final _notifications = FlutterLocalNotificationsPlugin();
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  })async=>
    _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload:payload
    );

  static Future _notificationDetails() async{
    print("[I'm called] test notif");
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id",
        "channel name",
        importance: Importance.max
      ),
      iOS: IOSNotificationDetails()
    );
  }
  }