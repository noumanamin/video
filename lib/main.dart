import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wekonact_agora_video_call/screens/home_page.dart';

var token = "006613504670dd340dba1daee589b01e9d0IABDWXjC6SwxmwO8qJ3kgKdD8tHaGzlUF7qP4zd5Ds0jJVbiCHoAAAAAIgA7wQAAo7oRZAQAAQAzdxBkAwAzdxBkAgAzdxBkBAAzdxBk";
// var token = "";

void main() {
  runApp(GetMaterialApp(
    home: WeKonactHomePage(),
  ));
}
class CallScreen extends StatefulWidget {
  final String? channelId;

  const CallScreen({Key? key, this.channelId}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isAudioOnly = true;
  int? _remoteUid;
  RtcEngine? _rtcEngine;

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    _rtcEngine = await RtcEngine.create('aa8160d03d634051be015e987dcb5132');

    await _rtcEngine!.enableVideo();
    await _rtcEngine!.setChannelProfile(ChannelProfile.Communication);
    // await _rtcEngine!.setClientRole(ClientRole.Audience);

    await _rtcEngine!.joinChannel(token, widget.channelId!, "Nouman", 0);

    _rtcEngine!.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        print('onError: $code');
        Fluttertoast.showToast(msg: 'Agora Error: $code');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('onJoinChannelSuccess: $channel, $uid, $elapsed');
        Fluttertoast.showToast(msg: 'Joined channel: $channel');
      },
      userJoined: (uid, elapsed) {
        print('onUserJoined: $uid, $elapsed');
        setState(() {
          _remoteUid = uid;
        });
      },
      leaveChannel: (stats) {
        print('onLeaveChannel');
        Fluttertoast.showToast(msg: 'Left channel');
        setState(() {
          _remoteUid = null;
        });
      },
    ));
  }

  void toggleAudioVideo() {
    setState(() {
      _isAudioOnly = !_isAudioOnly;
      if (_isAudioOnly) {
        _rtcEngine!.setClientRole(ClientRole.Audience);
        _rtcEngine!.disableVideo();
      } else {
        _rtcEngine!.setClientRole(ClientRole.Audience);
        _rtcEngine!.enableVideo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Call'),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: _remoteUid == null
                  ? Center(
                      child: Text('Waiting for someone to join...'),
                    )
                  : _isAudioOnly
                      ? RtcRemoteView.SurfaceView(
                          uid: _remoteUid!,
                          channelId: "demo_channel",
                        )
                      : Stack(
                          children: [
                            RtcRemoteView.SurfaceView(
                              uid: _remoteUid!,
                              channelId: "demo_channel",
                            ),
                            RtcLocalView.SurfaceView(),
                          ],
                        ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Audio Only'),
                Switch(
                  value: _isAudioOnly,
                  onChanged: (_) => toggleAudioVideo(),
                ),
                Text('Video'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rtcEngine!.leaveChannel();
    _rtcEngine!.destroy();
  }
}
