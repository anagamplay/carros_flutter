import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging? fcm;

void initFcm() {
  if (fcm == null) {
    fcm = FirebaseMessaging.instance;
  }

  fcm?.getToken().then((token) {
    print("\n******\nFirebase Token $token\n******\n");
  });

  fcm?.subscribeToTopic("all");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('\n\n\n*** on message $message');

    Map<String, dynamic> nome = message.data;
    print("onMessage: $nome");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('\n\n\n*** on resume $message');

    Map<String, dynamic> nome = message.data;
    print("onResume: $nome");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print('\n\n\n*** on launch $message');

    Map<String, dynamic> nome = message.data;
    print("onLaunch: $nome");
  });

  if (Platform.isIOS) {
    fcm?.requestPermission(sound: true, badge: true, alert: true);
    print('IOS Notification Settings: ${fcm?.getNotificationSettings}');
  }
}