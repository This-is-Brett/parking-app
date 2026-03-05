import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future init() async {

    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      iOS: ios,
    );

    await _notifications.initialize(settings);
  }

  static Future showWarning() async {

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      "Parking expiring",
      "⚠ Only 5 minutes remaining",
      details,
    );
  }
}