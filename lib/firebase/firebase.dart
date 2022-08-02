import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

FirebaseMessaging? fcm;

void initFcm() async{
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (fcm == null) {
    fcm = FirebaseMessaging.instance;
  }

  fcm?.getToken().then((token) {
    print("\n******\nFirebase Token $token\n******\n");
  });

  fcm?.subscribeToTopic("all");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('\n\n\n*** onMessage: title: ${message.notification?.title}, body: ${message.notification?.body}');

    print('onMessage: ${message.data['nome']}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('\n\n\n*** onResume: title: ${message.notification?.title}, body: ${message.notification?.body}');

    print('onResume: ${message.data['nome']}');
  });

  fcm?.getInitialMessage().asStream().listen((RemoteMessage? message) async {
      print('\n\n\n*** onLauch: title: ${message?.notification?.title}, body: ${message?.notification?.body}');

      print('onLauch: ${message?.data['nome']}');

  });

  if (Platform.isIOS) {
    NotificationSettings? settings = await fcm?.requestPermission(sound: true, badge: true, alert: true);
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings?.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}