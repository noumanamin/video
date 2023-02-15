import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../client/notification_client.dart';

class CallConnectionScreen extends StatelessWidget {
  var token;

  CallConnectionScreen({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Connecting please wait ...",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 10,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'End Call',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).onTap(() {
                Get.back();
                NotificationClient().sendNotification({
                  "to": "$token",
                  "data": {
                    "title": "Nouman Amin",
                    "body": "",
                    "type": "decline",
                    "channel_name": "abc",
                    "call_type": "decline",
                  }
                });
              }))
        ],
      ),
    );
  }
}
