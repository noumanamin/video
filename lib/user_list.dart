class UserList {
  int? userId;
  bool? audio;
  bool? video;

  UserList({this.userId, this.audio, this.video});
}
/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myController = TextEditingController();
  bool _validateError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agora Group Video Calling'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: NetworkImage(
                      'https://www.agora.io/en/wp-content/uploads/2019/07/agora-symbol-vertical.png'),
                  height: MediaQuery.of(context).size.height * 0.17,
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Agora Group Video Call Demo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      labelText: 'Channel Name',
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: 'test',
                      hintStyle: TextStyle(color: Colors.black45),
                      errorText:
                          _validateError ? 'Channel name is mandatory' : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: MaterialButton(
                    onPressed: onJoin,
                    height: 40,
                    color: Colors.blueAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Join',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      myController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });

    await handleCameraAndMic(Permission.camera);
    await handleCameraAndMic(Permission.microphone);

    Get.to(() => CallPage(channelName: myController.text));
  }
}

Future<void> handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
  print(status);
}


import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekonact_agora_video_call/screens/home_page.dart';

import '../user_list.dart';
import '../utils/utils.dart';

class CallPage extends StatefulWidget {
  final String? channelName;

  const CallPage({Key? key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine? _engine;
  List<UserList> userList = [
    UserList(
      userId: 1001,
      audio: false,
      video: false,
    )
  ];

  @override
  void dispose() {
    // clear users
    _users.clear();
    userList.clear();
    // destroy sdk
    _engine!.leaveChannel();
    _engine!.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (appID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine!.joinChannel(token, "abc", "Nouman", 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    await _engine!.enableVideo();
    await _engine!.enableAudio();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(HomePage());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Agora Group Video Calling'),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _toolbar(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                margin: EdgeInsets.only(top: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int index = 1;
                          index < _getRenderViews().length;
                          index++)
                        Container(
                          width: 120,
                          height: 180,
                          margin: EdgeInsets.only(
                            right:
                                index == _getRenderViews().length - 1 ? 12 : 4,
                            left: index == 1 ? 12 : 4,
                          ),
                          color: index.isEven ? Colors.red : Colors.yellow,
                          child: _expandedVideoRow([
                            _getRenderViews()[index],
                          ], flex: 0),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      userMuteAudio: (id, flag) {
        for (int index = 0; index < userList.length; index++) {
          if (userList[index].userId == id) {
            userList[index].audio = flag;
          }
        }
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          print("$elapsed");
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
          userList.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
          userList.add(UserList(
            userId: uid,
            audio: false,
            video: false,
          ));
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _infoStrings.add(info);
          _users.remove(uid);
          for (int index = 0; index < userList.length; index++) {
            if (userList[index].userId == uid) {
              userList.removeAt(index);
              break;
            }
          }
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          _infoStrings.add(info);
        });
      },
    ));
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine!.muteLocalAudioStream(muted);
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onSwitchCamera() {
    _engine!.switchCamera();
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            // _expandedVideoRow([views[1]])
          ],
        ));
    }
    return Container();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
          uid: uid,
          channelId: "abc",
        )));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views, {flex = 1}) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      flex: flex,
      child: Row(
        children: wrappedViews,
      ),
    );
  }
}

 */
/*
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
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../res/assets_res.dart';
import '../utils/app_utils.dart';
import '../utils/keycenter.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();

class VideoTalkPage extends StatefulWidget {
  final String? userToken;
  final String? channelName;
  final String? callerName;
  bool showInvite;

  VideoTalkPage({
    Key? key,
    this.userToken,
    this.callerName,
    this.showInvite = false,
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
      // print(ZegoAppUtils.sharePayLoad);
    });
    timer = Timer.periodic(Duration(seconds: 5), (timers) {
      users = ZegoUIKit.instance.getAllUsers().length;
      // ZegoUIKit.instanc
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
      child: Scaffold(
        body: Stack(
          children: [
            ZegoUIKitPrebuiltCall(
                appID: KeyCenter.instance.appID,
                appSign: KeyCenter.instance.appSign,
                userID: localUserID,
                userName: AppUtils.callerName,
                callID: widget.channelName!,
                config: callConfigs(users)),
            if (AppUtils.isCustomer)
              Positioned(
                right: 24,
                top: 24,
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset(
                    "packages/wekonact_agora_video_call/${AssetsRes.IMG_COLLABORATION}",
                    color: Colors.white,
                  ),
                ).onTap(share),
              )
          ],
        ),
      ),
    );
  }

  Future<void> share() async {
    print(AppUtils.sharePayLoad);

    if (AppUtils.sharePayLoad.isNotEmpty) {
      await FlutterShare.share(
          title: 'Call Invitation',
          text: AppUtils.sharePayLoad,
          chooserTitle: 'Example Chooser Title');
    }
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
    var optionsList = [
      ZegoMenuBarButtonName.toggleCameraButton,
      ZegoMenuBarButtonName.toggleMicrophoneButton,
      ZegoMenuBarButtonName.hangUpButton,
      ZegoMenuBarButtonName.switchAudioOutputButton,
      ZegoMenuBarButtonName.switchCameraButton,
      ZegoMenuBarButtonName.showMemberListButton,
    ];
    return ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
      ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(buttons: optionsList)
      ..useSpeakerWhenJoining = true
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

 */