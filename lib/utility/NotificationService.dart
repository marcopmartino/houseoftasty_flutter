import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo_medium');

   /* var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async{});*/

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {});
  }

  static Future<void> showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('104', 'ExpireProducts', channelDescription: 'Mostra prodotti scaduti');

    const NotificationDetails details =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    notificationsPlugin.show(104, title, body, details);
  }

}