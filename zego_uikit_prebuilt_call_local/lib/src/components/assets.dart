// Flutter imports:
import 'package:flutter/material.dart';

class PrebuiltCallImage {
  static Image asset(String name) {
    if (name ==
        "packages/zego_uikit_prebuilt_call_local/assets/icons/img_collaboration.png") {
      return Image.asset(
        name,
        color: Colors.white,
      );
    }
    return Image.asset(name);
    // return Image.asset(
    //   'packages/zego_uikit_prebuilt_call_local/assets/icons/top_member_normal.png',
    //   height: 24,
    // );
  }
}

class PrebuiltCallIconUrls {
  static const String back =
      'packages/zego_uikit_prebuilt_call_local/assets/icons/back.png';

  static const String topMemberNormal =
      'packages/zego_uikit_prebuilt_call_local/assets/icons/top_member_normal.png';
  static const String topCameraOverturn =
      'packages/zego_uikit_prebuilt_call_local/assets/icons/top_camera_overturn.png';
  static const String callInvitation =
      'packages/zego_uikit_prebuilt_call_local/assets/icons/img_collaboration.png';
}
