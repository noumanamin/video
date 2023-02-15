import 'package:get/get.dart';

import '../utils/app_utils.dart';

class UserListController extends GetxController {
  var userList = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getUserList();
    super.onInit();
  }

  getUserList() async {
    var deviceId = await AppUtils.getDeviceId();

    AppUtils.fireStore.collection("fcm_token").snapshots().listen((value) {
      print("data");
      userList.clear();
      for (int index = 0; index < value.docs.length; index++) {
        var data = value.docs[index].data();

        if (data['device_id'] != deviceId) {
          userList.add(data);
        }
      }
    });
    // FirebaseFirestore.instance.collection("fcm_token").get().then((value) {
    //
    // });
    userList.refresh();
  }
}
