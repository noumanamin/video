// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dialogs/flutter_dialogs.dart';
// import 'package:get/get.dart';
// import 'package:nb_utils/nb_utils.dart';
//
// import '../client/notification_client.dart';
// import '../utils/utils.dart';
//
// class RoomScreen extends StatefulWidget {
//   String? userToken;
//   String? channelName;
//   String? callerName;
//
//   RoomScreen({
//     Key? key,
//     this.channelName,
//     this.callerName,
//     required this.userToken,
//   }) : super(key: key);
//
//   @override
//   State<RoomScreen> createState() => _RoomScreenState();
// }
//
// class _RoomScreenState extends State<RoomScreen> {
//   RtcEngine? _engine;
//   static final _users = <int>[];
//
//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }
//
//   @override
//   void dispose() {
//     _users.clear();
//     _engine!.leaveChannel();
//     _engine!.destroy();
//     super.dispose();
//   }
//
//   Future<void> initialize() async {
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await _engine!.joinChannel(token, "abc", null, 0);
//   }
//
//   void _addAgoraEventHandlers() {
//     _engine!.setEventHandler(RtcEngineEventHandler(
//       error: (code) {
//         setState(() {
//           print('onError: $code');
//         });
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         print('onJoinChannel: $channel, uid: $uid');
//       },
//       leaveChannel: (stats) {
//         setState(() {
//           print('onLeaveChannel');
//           _users.clear();
//         });
//       },
//       userJoined: (uid, elapsed) {
//         print('userJoined: $uid');
//         setState(() {
//           _users.add(uid);
//         });
//       },
//     ));
//   }
//
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(appID);
//     await _engine!.enableAudio();
//     await _engine!.setChannelProfile(ChannelProfile.Communication);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         showPlatformDialog(
//           context: context,
//           builder: (context) => BasicDialogAlert(
//             title: const Text("Alert"),
//             content: const Text("Do you want to leave call?"),
//             actions: <Widget>[
//               BasicDialogAction(
//                 title: Text("No"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               BasicDialogAction(
//                 title: Text("Yes"),
//                 onPressed: () {
//                   quitCall();
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//
//         return true;
//       },
//       child: Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: Get.width,
//               height: Get.height * 0.14,
//             ),
//             Icon(
//               Icons.account_circle,
//               size: 120,
//             ),
//             SizedBox(
//               width: Get.width,
//               height: Get.height * 0.02,
//             ),
//             Text(
//               "${widget.callerName ?? ""}",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Expanded(
//               child: SizedBox(
//                 width: Get.width,
//                 height: Get.height * 0.02,
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(12),
//               margin: EdgeInsets.zero,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(60),
//               ),
//               child: const Icon(
//                 Icons.call,
//                 size: 40,
//                 color: Colors.white,
//               ),
//             ).onTap(() {
//               print("${widget.userToken}");
//               quitCall();
//
//               Get.back();
//             }),
//             SizedBox(
//               width: Get.width,
//               height: Get.height * 0.02,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void quitCall() {
//     NotificationClient().sendNotification({
//       "to": "${widget.userToken}",
//       "data": {
//         "title": "Nouman Amin",
//         "body": "",
//         "type": "end",
//         "channel_name": "abc",
//       }
//     });
//   }
// }
// /*
//  Container(
//             width: 100,
//             height: 100,
//             color: Colors.yellow,
//             child: Text("Click me"),
//           ).onTap(() {
//             NotificationClient().sendNotification({
//               "to": "${widget.receiver}",
//               "notification": {
//                 "body": "",
//                 "title": "Nouman Amin",
//                 "sound": "default"
//               },
//               "data": {
//                 "title": "Nouman Amin",
//                 "body": "",
//                 "type": "in_coming_call",
//                 "channel_name": "abc",
//                 "user_token": widget.sender
//               }
//             });
//
//             Get.to(() => CallConnectionScreen());
//           })
//  */
