import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
   Future<void> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Initialize the firebase messaging automatically once the app is opened
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    // This will access the token even if changes and store it in the preferences
    // for android devices
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async{
        await prefs.setString("fcm_token", token);
        String key = prefs.getString("fcm_token") ?? "";
        debugPrint("FCM Token: $key");
    },).onError((error, stackTrace){
      debugPrint("error: $error");
    });
    
    // Get the token for the first time
    await FirebaseMessaging.instance.getToken().then((token) async{
      if (token != null) {
        await prefs.setString("fcm_token", token);
        String key = prefs.getString("fcm_token") ?? "";
        debugPrint("FCM Token: $key");
      }
    },);
    // For iOS devices we need to get the APN token and set things up in the iOS developer console
    // https://firebase.google.com/docs/cloud-messaging/flutter/client?hl=en&authuser=0#ios
  }
}