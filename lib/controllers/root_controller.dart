import 'package:get/get.dart';
import '../utils/constants.dart';

class RootController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  var isLoading = false.obs;
  var notificationData = {}.obs;
  var unreadCategoryCounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getNotificationData();
  }

  Future<void> getNotificationData({bool refresh = false}) async {
    if (!refresh) isLoading.value = true;
    try {
      final response = await networkClient
          .postRequest(endPoint: 'list-notifications-for-admin', payload: {});
      notificationData.value = response.data ?? {};

      // here count logic
      final List<dynamic> notifications = notificationData['data'] ?? [];
      final Map<String, int> counts = {};

      // here i count unread every caategory
      for (var n in notifications) {
        final String category = n['category'] ?? "unknown";
        final bool isUnread = (n['is_read'] == 0);

        if (isUnread) {
          counts[category] = (counts[category] ?? 0) + 1;
        } else {
          counts.putIfAbsent(category, () => 0);
        }
      }

      counts["totalNotificationsCount"] =
          notificationData['totalNotificationsCount'] ?? 0;
      counts["totalBookingNotifications"] =
          notificationData['totalBookingNotifications'] ?? 0;
      counts["totalSharingNotifications"] =
          notificationData['totalSharingNotifications'] ?? 0;
      counts["totalPersonalNotifications"] =
          notificationData['totalPersonalNotifications'] ?? 0;

      unreadCategoryCounts.value = counts;
    } catch (e) {
      notificationData.clear();
      unreadCategoryCounts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final response = await networkClient.postRequest(
        endPoint: 'mark-notification-as-read-for-admin',
        payload: {"notification_id": notificationId},
      );

      if (response.statusCode == 200) {
        print("Notification $notificationId marked as read");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markCategoryAsRead(String categoryKey) async {
    try {
      final List<dynamic> notifications = notificationData['data'] ?? [];

      final List<int> idsToMark = notifications
          .where((n) => n['category'] == categoryKey && n['is_read'] == 0)
          .map<int>((n) => n['id'] as int)
          .toList();

      for (var id in idsToMark) {
        await markNotificationAsRead(id);
      }

      unreadCategoryCounts[categoryKey] = 0;
      unreadCategoryCounts.refresh();

      print("$categoryKey -> ${idsToMark.length} marked as read");
      getNotificationData(refresh: true);
    } catch (e) {
      print("Error marking $categoryKey as read: $e");
    }
  }
}
