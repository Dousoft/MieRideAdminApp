import 'package:get/get.dart';
import '../utils/constants.dart';

class RootController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  var isLoading = false.obs;
  var notificationData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getNotificationData();
  }

  Future<void> getNotificationData({bool refresh = false}) async {
    if(!refresh)isLoading.value = true;
    try {
      final response = await networkClient.postRequest(
          endPoint: 'list-notifications-for-admin', payload: {});
      notificationData.value = response.data ?? {};
    } catch (e) {
      notificationData.clear();
    } finally {
      isLoading.value = false;
    }
  }
}