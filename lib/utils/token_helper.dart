// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
//
// import '../keycenter.dart';
// import 'user_id_helper.dart';
//
// class TokenHelper {
//   static final TokenHelper instance = TokenHelper._internal();
//
//   TokenHelper._internal();
//
//   Future<String> getToken(String roomId) async {
//     if (KeyCenter.instance.token.isNotEmpty) {
//       return Future.value(KeyCenter.instance.token);
//     } else {
//       if (KeyCenter.instance.tokenServer.isEmpty) {
//         throw Exception(
//             'You should fill in the "token" value in "keycenter.dart" file when running on web!');
//       }
//       return _getTokenFromServer(
//           KeyCenter.instance.appID, UserIdHelper.instance.userID, roomId);
//     }
//   }
//
//   Future<String> _getTokenFromServer(
//       int appId, String userId, String roomId) async {
//     Map params = {
//       'appId': appId,
//       'idName': userId,
//       'roomId': roomId,
//       'version': '03',
//       'privilege': {'1': 1, '2': 1},
//       'expire_time': 7 * 24 * 60 * 60
//     };
//
//     String url = KeyCenter.instance.tokenServer;
//     HttpClientRequest request = await HttpClient().postUrl(Uri.parse(url));
//     request.headers.set('content-type', 'application/json');
//     request.add(utf8.encode(json.encode(params)));
//
//     HttpClientResponse response = await request.close();
//     String result = '';
//     String responseBody = await response.transform(utf8.decoder).join();
//     if (response.statusCode == HttpStatus.ok) {
//       result = jsonDecode(responseBody)['data']['token'];
//     }
//     return result;
//   }
// }
