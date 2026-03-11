import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future init() async {

    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      iOS: ios,
    );

    await notifications.initialize(settings);

    /// Request permissions explicitly
    final iosPlugin =
        notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future showWarning() async {

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      iOS: iosDetails,
    );

    await notifications.show(
      0,
      "Parking Warning",
      "5 minutes remaining",
      details,
    );
  }
}