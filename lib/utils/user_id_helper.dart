import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

class UserIdHelper {
  static final UserIdHelper instance = UserIdHelper._internal();
  UserIdHelper._internal();

  String _userID = '';

  String _userName = '';

  String get userID {
    if (_userID.isEmpty) {
      // Generate a random user id
      String hostPlatform = Platform.operatingSystem;
      String webPrefix = kIsWeb ? 'web_' : '';
      int randomNumber = Random().nextInt(10000) + 1000;
      _userID = 'flutter_${webPrefix}${hostPlatform}_${randomNumber}';
    }
    return _userID;
  }

  String get userName {
    if (_userName.isEmpty) {
      _userName = userID;
    }
    return _userName;
  }

  set userID(String userID_) => _userID = userID_;

  set userName(String userName_) => _userName = userName_;
}
