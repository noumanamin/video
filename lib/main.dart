import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekonact_agora_video_call/services/awesome_notifcation_service.dart';

import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  await AwesomeNotificationService.initializeAwesomeNotification();
  await AwesomeNotificationService.listenToActions();
  await AwesomeNotificationService.setupNotificationAction();

  // await handleCameraAndMic(Permission.camera);
  // await handleCameraAndMic(Permission.microphone);
  // await FirebaseService().setUpFirebaseMessaging();

  // FirebaseMessaging.onBackgroundMessage(
  //     GeneralAppService.onBackgroundMessageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeKonactHomePage(),
    );
  }
}
