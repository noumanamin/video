import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wekonact_agora_video_call/screens/call_connection_screen.dart';
import 'package:wekonact_agora_video_call/utils/app_utils.dart';

import '../client/notification_client.dart';
import '../controllers/user_list_controller.dart';
import '../main.dart';
import '../services/firebase_service.dart';
import '../widget/call_type_dialog.dart';
import 'call_screen.dart';

class WeKonactHomePage extends StatefulWidget {
  WeKonactHomePage({instance, messaging, userId}) {
    if (instance != null) {
      final UserListController _controller = Get.put(UserListController());
    }
  }

  @override
  WeKonactHomePageState createState() => WeKonactHomePageState();
}

class WeKonactHomePageState extends State<WeKonactHomePage> {
  final myController = TextEditingController();
  bool _validateError = false;
  final UserListController _controller = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var userList = _controller.userList.value;
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agora Group Video Calling'),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              ListView(
                children: [
                  for (int index = 0; index < userList.length + 0; index++)
                    userItem(index, userList[index], (userList.length + 0) - 1),
                  AppButton(
                    text: "Open Page",
                    textColor: Colors.black,
                    color: Colors.amber,
                    onTap: () async {
                      AppUtils.callerName = "Nouman Amin";
                      // openDialog(callType: "audio", channelId: "abc", token: token);
                      Get.to(CallPage(
                        channelName: "36",
                        callerName: "Nouman",
                        userToken: '',
                      ));
                      // String tokenStr = await getRTCToken("abc");
                      // print("RTC Token: $tokenStr");
                    },
                  )
                ],
              ).expand(),
              Divider(),
              Text("$deviceId")
            ],
          ),
        ),
      );
    });
  }

  Future<void> onJoin() async {
    setState(() {
      myController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });

    // await handleCameraAndMic(Permission.camera);
    // await handleCameraAndMic(Permission.microphone);

    // Get.to(() => CallPage(
    //       channelName: myController.text,
    //       userToken: userToken,
    //     ));
  }

  userItem(int index, userValue, size) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.account_circle,
              size: 72,
              color: Colors.grey,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User ${index + 1}",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    userValue['device_id'],
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ).onTap(() {
          Get.dialog(CallTypeDialog(
            onTapBtn: (value) {
              // dialCall("audio", "abc");
              AppUtils.callerName = "Nouman Amin";
              openDialog(
                callType: "audio",
                channelId: "abc",
                token: token,
              );
            },
          ));
          // showPlatformDialog(
          //   context: context,
          //   builder: (context) => BasicDialogAlert(
          //     title: Text("Current Location Not Available"),
          //     content: Text(
          //         "Your current location cannot be determined at this time."),
          //     actions: <Widget>[
          //       BasicDialogAction(
          //         title: Text("OK"),
          //         onPressed: () {
          //           dialCall("video", userValue);
          //         },
          //       ),
          //     ],
          //   ),
          // );

          // Get.to(RoomScreen(receiver:userValue['fcm_token'],sender:userToken));
        }),
        Divider(
          color: index == size ? Colors.transparent : Colors.grey,
        )
      ],
    ).marginOnly(left: 12, right: 12, top: index == 0 ? 12 : 0);
  }
}

openDialog({callType, required channelId, required token}) {
  // dialCall("audio", channelId);
  Get.dialog(CallTypeDialog(
    onTapBtn: (value) {
      dialCall(value, channelId, token);
    },
  ));
}

void dialCall(String callType, channelId, token) {
  Get.back();
  NotificationClient().sendNotification({
    "to": AppUtils.receiverToken,
    "data": {
      "title": AppUtils.senderName,
      "body": "",
      "type": "in_coming_call",
      "channel_name": channelId,
      "alert_type": "call",
      "call_type": callType,
      "rtc_token": token,
      "receiver": AppUtils.receiverToken,
      "user_token": AppUtils.senderToken
    }
  });

  Get.to(() => CallConnectionScreen(token: AppUtils.receiverToken));
}

Future<String> getRTCToken(String channelName) async {
  var response = await NotificationClient().getToken(channelName);
  if (response.isNotEmpty) {
    token = response;
    print("rtc token: $token");
    return response.toString().trim();
  }

  return "";
}
