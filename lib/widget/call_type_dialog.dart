import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class CallTypeDialog extends StatelessWidget {
  CallTypeDialog({Key? key, this.onTapBtn}) : super(key: key);

  var onTapBtn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
          ).onTap(() {
            Get.back();
          }),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                width: Get.width,
                child: Column(
                  children: [
                    SizedBox(
                      width: Get.width,
                      child: const Text(
                        'Audio Call',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ).paddingSymmetric(vertical: 16, horizontal: 24),
                    ).onTap(() {
                      onTapBtn("audio");
                    }),
                    Divider(),
                    SizedBox(
                      width: Get.width,
                      child: const Text(
                        'Video Call',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ).paddingSymmetric(vertical: 16, horizontal: 24),
                    ).onTap(() {
                      onTapBtn("video");
                    })
                  ],
                ),
              ).marginSymmetric(horizontal: 24)
            ],
          ),
        ],
      ),
    );
  }
}
