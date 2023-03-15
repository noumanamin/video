import 'package:get/get.dart';

import '../utils/app_utils.dart';

class NotificationClient extends GetHttpClient {
  sendNotification(body) async {
    String path = 'https://fcm.googleapis.com/fcm/send';
    Map<String, String> requestHeaders = {
      'Authorization':
          'key=AAAAOXNcGzI:APA91bHpNunBHHV5TFPfge4_CtoXY6QgZax-r0WBdVapjU8OGjPNh1Je_TRjlCJOK0dmz5HmypPKUWekOeVKTb3m-aGqws9DtbQbYy54fVudAc7sUTtBSA29TGTNSQm_cVQI5yNL_IO2',
      "content-type": "application/json",
    };
    body['to'] = AppUtils.receiverToken;
    body['data']["alert_type"] = "call";
    var response = await GetHttpClient().post(
      path,
      headers: requestHeaders,
      body: body,
    );
    print("");
  }

  saveHistory(body, url, token) async {
    Map<String, String> requestHeaders = {
      "content-type": "application/json",
    };

    var response = await GetHttpClient().post(
      url,
      headers: requestHeaders,
      body: body,
    );
    print("");
  }

  Future<String> getToken(String channelName) async {
    String urls =
        "https://call.wekonact.pk/Tools/DynamicKey/AgoraDynamicKey/php/sample/RtcTokenBuilderSample.php?channel=$channelName";

    var response = await GetHttpClient().get(
      urls,
    );
    if (response.body == null) {
      return await getToken(channelName);
    }
    if (response.statusCode == 200 && response.statusText == "OK") {
      if (response.body.toString().contains("Token with int uid")) {
        return response.body.toString().split("uid:")[1];
      }
    }

    return "";
  }
}
