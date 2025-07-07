import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseService {
  final _storage = const FlutterSecureStorage();
   Future<void> getFCMToken() async {
    // Initialize the firebase messaging automatically once the app is opened
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    // This will access the token even if changes and store it in the preferences
    // for android devices
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async{
        await _storage.write(key: "fcmToken", value: token);
        String key = await _storage.read(key: "fcmToken") ?? "";
        debugPrint("FCM Token: $key");
    },).onError((error, stackTrace){
      debugPrint("error: $error");
    });
    
    // Get the token for the first time
    await FirebaseMessaging.instance.getToken().then((token) async{
      if (token != null) {
        await _storage.write(key: "fcmToken", value: token);
        String key = await _storage.read(key: "fcmToken") ?? "";
        debugPrint("FCM Token: $key");
      }
    },);
    // For iOS devices we need to get the APN token and set things up in the iOS developer console
    // https://firebase.google.com/docs/cloud-messaging/flutter/client?hl=en&authuser=0#ios
  }
}