import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:fixit/services/notificationApi.dart';
import 'package:fixit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './components/splashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laravel_flutter_pusher/laravel_flutter_pusher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Pusher/pusher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// const listenEvent = "listeEvent";

// void getNotifications(String partnerKeyAndId) {
//   var test = PusherService();
//   LaravelFlutterPusher pusher = test.initPusher(WebsocketSettings.key,
//       WebsocketSettings.ip, WebsocketSettings.port, WebsocketSettings.cluster);
//   // StreamController<dynamic> controller = StreamController<dynamic>();
//   // Stream stream = controller.stream;
//   pusher.subscribe(partnerKeyAndId).bind(WebsocketSettings.partnerChannel,
//       (event) async {
//     // print(event);
//     print("[Pusher] $partnerKeyAndId");
//     await NotificationApi.showNotification(
//         title: "Hey! you got an order!",
//         body: "Hey, someone just sent you an order.",
//         payload: "");
//     // controller.add(event);
//   });
// }

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case listenEvent:
//         // Code to run in background
//         getNotifications(inputData!['partnerId']);
//         break;
//     }
//     return Future.value(true);
//   });
// }

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel", "High importance notification",
    description: "this is important notification",
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("bg message just showed up: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  var token = await FirebaseMessaging.instance.getToken();
  final storage = FlutterSecureStorage();
  await storage.write(key: deviceTokenKey, value: token);
  print("firebase token $token");
  // final storage = FlutterSecureStorage();
  // var partnerId = await storage.read(key: partnerIdKey);
  // if (partnerId != null) {
  //   await Workmanager().initialize(
  //     callbackDispatcher,
  //   );
  //   await Workmanager().registerOneOffTask("1", listenEvent,
  //       constraints: Constraints(
  //         networkType: NetworkType.connected,
  //       ),
  //       inputData: {"partnerId": "partner.$partnerId"});
  // }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("[Notification] ${notification?.body}");
      print("[Notification] ${message.data}");
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.blue,
                    icon: '@mipmap/ic_launcher',
                    playSound: true)));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text("${notification.title}"),
            content: SingleChildScrollView(child: Column(children: [Text("${notification.body}")],)),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext contextP) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('es'), // Spanish
          Locale('fr'), // French
          Locale('id'), // Chinese
        ],
        home: SplashScreen());
  }
}
