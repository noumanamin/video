import '../utils/app_utils.dart';

String userToken = "";
String? deviceId = "";

class CustomFirebaseService {
  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // setUpFirebaseMessaging() async {
  //   //Request for notification permission
  //   /*NotificationSettings settings = */
  //   await saveToken();
  //   await firebaseMessaging.requestPermission();
  //
  //   //on notification tap tp bring app back to life
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  //
  //   //normal notification listener
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("onMessage");
  //     AwesomeNotificationService().showNotification(message.data);
  //   });
  // }

  saveToken(messaging, userId, name, {userType = "customers"}) async {
    userId = userId.toString();
    AppUtils.messaging.getToken().then((token) async {
      userToken = token!;
      print("fcm token: $userToken");
      // deviceId = await AppUtils.getDeviceId();
      print("device iD: $userId");

      AppUtils.senderName = name;
      AppUtils.senderToken = token;

      var instance = AppUtils.fireStore;
      var data = await instance
          .collection(userType)
          .where("user_id", isEqualTo: userId)
          .get();

      if (data.docs.isEmpty) {
        Map<String, dynamic> body = <String, dynamic>{
          "user_id": userId,
          "fcm_token": token,
          "name": name,
        };
        saveTokenToFirebase(body, userType);
      } else {
        Map<String, dynamic> body = <String, dynamic>{
          "user_id": userId,
          "fcm_token": token,
          "name": name,
        };
        updateTokenToFirebase(body, userType);
      }
      print("abc");
    });
  }

  void saveTokenToFirebase(Map<String, dynamic> body, userType) {
    var instance = AppUtils.fireStore;

    try {
      instance
          .collection(userType)
          .doc(body['user_id'])
          .set(body)
          .whenComplete(() {
        print("");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void updateTokenToFirebase(Map<String, dynamic> body, userType) {
    var instance = AppUtils.fireStore;

    try {
      instance
          .collection(userType)
          .doc(body['user_id'])
          .update(body)
          .whenComplete(() {
        print("");
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> getReceiverToken(id,
      {userType = "customers"}) async {
    String vendorId = "";
    var instance = AppUtils.fireStore;
    var data = await instance
        .collection(userType)
        .where("user_id", isEqualTo: id)
        .get();

    Map<String, dynamic> body = <String, String>{};

    if (!data.docs.isEmpty) {
      var dataz = data.docs.first.data();
      return dataz;
    }
    return body;
  }
}
