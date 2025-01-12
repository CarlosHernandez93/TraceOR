import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_medical_foreground");

    const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings
    );

    void onNotificationTap(NotificationResponse response){
      //Se puede hacer que cuando toque sobre la notificacion te lleve a la pantalla
      print("Notification checked: ${response.payload}");
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  Future<void> showInstantNotification() async{
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      "high_importance_channel",
      "Important Notifications",
      channelDescription: "Canal para mostrar notificaciones al instante que se registrar un cambio en Firebase",
      importance: Importance.max,
      priority: Priority.high
    );

    const NotificationDetails platformChannelSpecifies = NotificationDetails(android: androidNotificationDetails);

    //Se puede personalizar
    await flutterLocalNotificationsPlugin.show(
      0,
      'Title of notification',
      'Description of notification',
      platformChannelSpecifies,
      payload: 'instant'
    );
  }
}