import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:wekonact_agora_video_call/client/notification_client.dart';
import 'package:wekonact_agora_video_call/screens/video_talk_page.dart';
import 'package:wekonact_agora_video_call/services/firebase_service.dart';
import 'package:wekonact_agora_video_call/utils/app_utils.dart';

class AwesomeNotificationService {
  //
  static const platform = MethodChannel('notifications.manage');

  //
  static initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/ic_launcher',
      [
        appNotificationChannel(),
      ],
    );
    //requet notifcation permission if not allowed
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static NotificationChannel appNotificationChannel() {
    //firebase fall back channel key
    //fcm_fallback_notification_channel
    return NotificationChannel(
      channelKey: '10001',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for app',
      importance: NotificationImportance.High,
      playSound: true,
    );
  }

  showNotification(payload) async {
    if (payload["type"] == "in_coming_call") {
      CallKitParams params = getParams(payload);
      await FlutterCallkitIncoming.showCallkitIncoming(params);
    } else if (payload["type"] == "call_accepted") {
      print("accepted");
      Get.off(
        VideoTalkPage(
          channelName: payload['channel_name'],
          userToken: payload['user_token'],
        ),
      );
      // if (payload['call_type'] == "audio") {
      //   String rName = AppUtils.receiverName;
      //   String sName = AppUtils.senderName;
      //   Get.off(
      //     RoomScreen(
      //       channelName: payload['channel_name'],
      //       userToken: payload['user_token'],
      //       callerName: rName,
      //     ),
      //   );
      // } else {
      //   Get.off(CallPage(
      //     channelName: payload['channel_name'],
      //     userToken: payload['user_token'],
      //   ));
      // }
    } else if (payload["type"] == "decline") {
      print("accepted");
      await FlutterCallkitIncoming.endAllCalls();
      Get.back();
      // CallKitParams params = getParams(payload);
      // await FlutterCallkitIncoming.showMissCallNotification(params);
    } else if (payload["type"] == "end") {
      print("accepted");
      // Get.offAll(HomePage());
      Get.back();
      // CallKitParams params = getParams(payload);
      // await FlutterCallkitIncoming.showMissCallNotification(params);
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: Random().nextInt(10000),
            channelKey: "10001",
            title: payload["title"],
            body: payload['body'],
            icon: "resource://drawable/ic_launcher",
            notificationLayout: NotificationLayout.Default,
            category: NotificationCategory.Call),
      );
    }
  }

  static setupNotificationAction() async {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      print("actions list");
      switch (event!.event) {
        case Event.ACTION_CALL_INCOMING:
          print('incoming call gaes');
          break;
        case Event.ACTION_CALL_ACCEPT:
          print('body ' + event.body['extra']['channel_name']);
          print('body ' + event.body['extra']['call_type']);
          NotificationClient().sendNotification({
            "to": "${event.body['extra']['user_token']}",
            "data": {
              "title": "",
              "body": "",
              "call_type": event.body['extra']['call_type'],
              "type": "call_accepted",
              "channel_name": "abc",
              "user_token": userToken
            }
          });

          3.delay().then((value) {
            Get.to(
              VideoTalkPage(
                channelName: event.body['extra']['channel_name'],
                userToken: event.body['extra']['user_token'],
              ),
            );
          });
          // if (event.body['extra']['call_type'] == "audio") {
          //   // Get.offAll(HomePage());
          //
          //   // await Future.delayed(Duration(seconds: 3));
          //
          //   Get.to(
          //     RoomScreen(
          //       channelName: event.body['extra']['channel_name'],
          //       callerName: event.body['nameCaller'],
          //       userToken: event.body['extra']['user_token'],
          //     ),
          //   );
          // } else {
          //   Get.to(CallPage(
          //     channelName: event.body['extra']['channel_name'],
          //     callerName: event.body['caller_name'],
          //     userToken: event.body['extra']['user_token'],
          //   ));
          // }

          break;
        case Event.ACTION_CALL_DECLINE:
          print('declien call gaes');

          NotificationClient().sendNotification({
            "to": "${event.body['extra']['user_token']}",
            "notification": {"body": "", "title": "", "sound": "default"},
            "data": {
              "title": "",
              "body": "",
              "call_type": event.body['extra']['call_type'],
              "type": "decline",
              "channel_name": "abc"
            }
          });

          break;
        case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_START:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_ENDED:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_TIMEOUT:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_CALLBACK:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_TOGGLE_HOLD:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_TOGGLE_MUTE:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_TOGGLE_DMTF:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_TOGGLE_GROUP:
          // TODO: Handle this case.
          break;
        case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: Handle this case.
          break;
      }
    });
  }

  static listenToActions() {
    // AwesomeNotifications().setListeners(onActionReceivedMethod: (event) async {
    //   print("onActionReceivedMethod");
    // });
  }

  getParams(payload) {
    AppUtils.receiverName = payload['title'];
    AppUtils.receiverToken = payload['user_token'];
    CallKitParams paramsKit = CallKitParams(
        textAccept: "Accept",
        nameCaller: payload['title'],
        appName: "Video",
        textDecline: "Decline",
        extra: <String, dynamic>{
          "channel_name": payload['channel_name'],
          "user_name": payload['title'],
          "user_token": payload['user_token'],
          "call_type": payload['call_type'],
          "caller_name": payload['caller_name']
        });
    return paramsKit;
  }
}
