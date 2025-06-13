import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../configs/my_logger.dart';

Future<void> firebaseOnBackgroundMessage(RemoteMessage message) async {
  MyLogger.info("Handling a background message: ${message.messageId}");
  MyLogger.info('firebaseOnBackgroundMessage: ${message.notification?.title}');
  MyLogger.info('firebaseOnBackgroundMessage: ${message.notification?.body}');
}

class NotificationServices {
  //initialising firebase message plugin
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidInitializationSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        print('::: payload $payload');
        // handle interaction when app is active for android
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        if (kDebugMode) {
          print("notifications title: ${notification.title}");
          print("notifications body: ${notification.body}");
          print("notification : ${notification}");
          print("notification ad pending : ${message.data['type']}");
          // Check if the notification type is `spare_part_status`

          if (android != null) {
            print('count: ${android.count}');
          }
          print('data: ${message.data.toString()}');
        }

        if (Platform.isIOS) {
          forgroundMessage();
        }

        if (Platform.isAndroid) {
          initLocalNotifications(context, message);
          showNotification(message);
        }
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      MyLogger.info('user granted provisional permission');
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
    getDeviceToken();
  }

  //function to get device token on which we will send the notifications
  static Future getDeviceToken({int maxRetires = 3}) async {
    try {
      String? token;

      token = await messaging.getToken();

      return token;
    } catch (e) {
      return null;
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: 'your channel description',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
          sound: channel.sound,
          //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
          //  icon: largeIconPath
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    MyLogger.info(':::data of handling notification  ${message.data['type']}');
    MyLogger.info('should navigate now ');
    MyLogger.info('${message.toMap()} ');

    // currently we have these types  message and ad_live
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}



//  how to use 

// declare some where in main file top level function

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }
// then in main 
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//  call this in the start of app   NotificationServices notificationServices = NotificationServices();

// then  in init 

    // notificationServices.requestNotificationPermission();
    // notificationServices
    //     .getDeviceToken()
    //     .then((value) => { if(kDebugMode)print('::: device FCM token: $value')});
    // notificationServices.setupInteractMessage(context);
    // notificationServices.firebaseInit(context);

// for ios add apn in firebase 