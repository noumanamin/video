import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../client/notification_client.dart';
import '../main.dart';
import '../res/assets_res.dart';
import '../user_list.dart';
import '../utils/app_utils.dart';

class CallPage extends StatefulWidget {
  String? userToken;
  String? channelName;
  String? callerName;
  bool showInvite;

  CallPage({
    Key? key,
    required this.channelName,
    this.callerName,
    this.showInvite = false,
    required this.userToken,
  }) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool _isAudioOnly = false;
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
    if (AppUtils.appId.isEmpty) {
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
    await _engine!.joinChannel(token, widget.channelName!, "Nouman", 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(AppUtils.appId);
    await _engine!.enableVideo();
    await _engine!.enableAudio();

    _engine!.setAudioProfile(AudioProfile.MusicStandard, AudioScenario.MEETING);
    _engine!.setVideoEncoderConfiguration(VideoEncoderConfiguration(
      dimensions: VideoDimensions(width: 1920, height: 1080),
      frameRate: VideoFrameRate.Fps30,
      bitrate: 5000,
      orientationMode: VideoOutputOrientationMode.Adaptative,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.offAll(WeKonactHomePage());
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _toolbar(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
                margin: EdgeInsets.only(top: 48),
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
                          color: Colors.black.withOpacity(0.5),
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
    quitCall();
    Get.back();
  }

  void quitCall() {
    NotificationClient().sendNotification({
      "to": "${widget.userToken}",
      "data": {
        "title": "",
        "body": "",
        "type": "end",
        "channel_name": "abc",
      }
    });
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Image.asset(
              _isAudioOnly
                  ? "packages/wekonact_agora_video_call/${AssetsRes.IMG__CAMERA_ON}"
                  : "packages/wekonact_agora_video_call/${AssetsRes.IMG_CAMERA_OFF}",
              color: muted ? Colors.white : Colors.blueAccent,
            ),
          ).onTap(() {
            toggleAudioVideo();
          }),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ).onTap(() {
            _onToggleMute();
          }),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          ).onTap(() {
            _onSwitchCamera();
          }),
          const SizedBox(width: 12),
          if (AppUtils.isCustomer)
            Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset(
                "packages/wekonact_agora_video_call/${AssetsRes.IMG_COLLABORATION}",
                // "${AssetsRes.IMG_COLLABORATION}",
                color: Colors.blueAccent,
              ),
            ).onTap(() {
              share();
            })
        ],
      ),
    );
  }

  void toggleAudioVideo() {
    setState(() {
      _isAudioOnly = !_isAudioOnly;
      if (_isAudioOnly) {
        _engine!.setClientRole(ClientRole.Audience);
        _engine!.disableVideo();
      } else {
        _engine!.setClientRole(ClientRole.Audience);
        _engine!.enableVideo();
      }
    });
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

  void _onSwitchCamera() {
    _engine!.switchCamera();
    _engine!.enableVideo();
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
          channelId: widget.channelName!,
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
