import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class AppUtils {
  static String senderToken = "";
  static String senderName = "";
  static String receiverToken = "";
  static String receiverName = "";

  static String callerName = "";

  static String channelId = "";

  static String urlPrefix = '';
  static String webLink = '';
  static String userName = '';

  static var fireStore;
  static var messaging;

  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }
}
