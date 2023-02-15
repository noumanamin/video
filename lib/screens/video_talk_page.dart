//
//  video_talk_page.dart
//  zego-express-example-topics-flutter
//
//  Created by Patrick Fu on 2020/11/16.
//  Copyright © 2020 Zego. All rights reserved.
//

// Dart imports:
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call_local/zego_uikit_prebuilt_call.dart';

import '../utils/app_utils.dart';
import '../utils/keycenter.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

class VideoTalkPage extends StatefulWidget {
  final String? userToken;
  final String? channelName;
  final String? callerName;

  const VideoTalkPage({
    Key? key,
    this.userToken,
    this.callerName,
    required this.channelName,
  }) : super(key: key);

  @override
  State<VideoTalkPage> createState() => _VideoTalkPageState();
}

class _VideoTalkPageState extends State<VideoTalkPage> {
  Timer? timer;

  int users = 0;

  @override
  void initState() {
    2.delay().then((value) async {
      // String shortLink = await getShortLink();
      // ZegoAppUtils.sharePayLoad = shortLink;
      print(ZegoAppUtils.sharePayLoad);
    });
    timer = Timer.periodic(Duration(seconds: 5), (timers) {
      users = ZegoUIKit.instance.getAllUsers().length;
      print("${timers.tick}");
      if (timers.tick % 3 == 0) {
        users = 4;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
          appID: KeyCenter.instance.appID,
          appSign: KeyCenter.instance.appSign,
          userID: localUserID,
          userName: AppUtils.callerName,
          callID: widget.channelName!,
          config: callConfigs(users)),
    );
  }

  callConfigs(int usersCount) {
    // if (usersCount > 2000) {
    //   return ZegoUIKitPrebuiltCallConfig.groupVideoCall()
    //     ..onHangUp = () {
    //       print("object");
    //     }
    //     ..onHangUpConfirmation = (vale) async {
    //       print("on leave");
    //       if (timer != null) {
    //         timer!.cancel();
    //       }
    //       Navigator.of(context).pop();
    //       // Get.offAll(HomePage());
    //       return true;
    //     }
    //     ..onOnlySelfInRoom = (context) {
    //       if (timer != null) {
    //         timer!.cancel();
    //       }
    //       Navigator.of(context).pop();
    //     };
    // }
    return ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
      ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(buttons: [
        ZegoMenuBarButtonName.toggleCameraButton,
        ZegoMenuBarButtonName.toggleMicrophoneButton,
        ZegoMenuBarButtonName.hangUpButton,
        ZegoMenuBarButtonName.switchAudioOutputButton,
        ZegoMenuBarButtonName.inviteCallButton,
        ZegoMenuBarButtonName.switchCameraButton,
        ZegoMenuBarButtonName.showMemberListButton,
      ])
      ..onHangUp = () {
        print("object");
      }
      ..onHangUpConfirmation = (vale) async {
        print("on leave");
        if (timer != null) {
          timer!.cancel();
        }
        Navigator.of(context).pop();
        // Get.offAll(HomePage());
        return true;
      }
      ..onOnlySelfInRoom = (context) {
        if (timer != null) {
          timer!.cancel();
        }
        Navigator.of(context).pop();
      };
  }
}
// Future<String> getShortLink() async {
//
//   Map<String, dynamic> body = {
//     "channel_name": "abc",
//   };
//   String credentials = json.encode(body);
//   Codec<String, String> stringToBase64 = utf8.fuse(base64);
//   String encoded = stringToBase64
//       .encode(credentials); // dXNlcm5hbWU6cGFzc3dvcmQ=
//   String decoded = stringToBase64.decode(encoded);
//   var maps = json.decode(decoded);
//   print("");
//   final DynamicLinkParameters parameters =
//   DynamicLinkParameters(
//     uriPrefix: 'https://${AppUtils.urlPrefix}',
//     link: Uri.parse('shop.wekonact.com/?link=$credentials'),
//     androidParameters: AndroidParameters(
//       packageName: 'com.soft.wekonact',
//       minimumVersion: 1,
//     ),
//   );
//   var dynamicUrl = await parameters.buildShortLink();
//   // dynamicUrl.shortUrl.toString();
//   final Uri shortUrl = dynamicUrl.shortUrl;
//
//   print(shortUrl.toString());
//
//   return shortUrl.toString();
// }
/*
final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(link),
      uriPrefix: AppDynamicLink.dynamicLinkPrefix,
      androidParameters: AndroidParameters(
        packageName: await AppDynamicLink.androidDynamicLinkId,
      ),
      iosParameters: IosParameters(
        bundleId: await AppDynamicLink.iOSDynamicLinkId,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(
      dynamicLinkParams,
    );

    String shareLink = Uri.decodeFull(
      Uri.decodeComponent(dynamicLink.toString()),
    );
 */
