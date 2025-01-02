import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:style_line/app/app.dart';
import 'package:style_line/services/db/cache.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await init.initMapkit(
    apiKey: dotenv.env["15c1d849-cd77-420d-acf7-fdf37c9d4e58"] ??
        "15c1d849-cd77-420d-acf7-fdf37c9d4e58",
  );

  await Firebase.initializeApp();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      if (notificationResponse.payload != null) {
        print('Payload: ${notificationResponse.payload}');
      }
    },
  );

  await cache.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
    carPlay: false,
    criticalAlert: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Уведомления разрешены.');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('Уведомления временно разрешены.');
  } else {
    print('Уведомления отклонены.');
  }

  String? token = await messaging.getToken();
  print("FCM Token: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Получено уведомление: ${message.notification?.title}');
    _showNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Уведомление открыто: ${message.notification?.title}');
  });

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('uz'),
        Locale('ru'),
        Locale('uk'),
      ],
      startLocale: const Locale('uz'),
      child: App(),
    ),
  );
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'default_channel',
    'Default',
    channelDescription: 'Канал по умолчанию для уведомлений',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'Нет заголовка',
    message.notification?.body ?? 'Нет текста',
    platformChannelSpecifics,
    payload: message.data.toString(),
  );
}
