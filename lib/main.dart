import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tech/bindings/bindings.dart';
import 'package:tech/firebase_options.dart';
import 'package:tech/routes/routes.dart';
import 'package:tech/service/firebase_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await firebaseMessageInit();
  WebViewPlatform.instance;
  runApp(const MyApp());
}

Future<void> firebaseMessageInit() async {
  final FirebaseService firebaseService = FirebaseService();
  await firebaseService.getFCMToken();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.onBoarding,
      getPages: AppScreens.screens,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
    );
  }
}
