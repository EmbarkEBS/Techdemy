// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tech/bindings/bindings.dart';
// import 'package:tech/firebase_options.dart';
import 'package:tech/routes/routes.dart';
import 'package:tech/service/api_service.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();
  await apiService.logActivity();
  HttpOverrides.global = MyHttpOverrides();
  bool isLoggedIn = await apiService.checkLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialRoute: AppRoutes.onBoarding,
      initialRoute: isLoggedIn ? AppRoutes.bottom : AppRoutes.onBoarding,
      getPages: AppScreens.screens,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      theme: ThemeData(
        useMaterial3: true,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.yellow,
          circularTrackColor: Colors.black,
          trackGap: 3.0
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ))
          )
        )
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
