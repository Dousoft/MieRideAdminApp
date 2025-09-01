import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/constants.dart';
import 'package:mie_admin/utils/tabs/app_custom_tab.dart';

import '../../controllers/root_controller.dart';
import '../booking/family/faimaly_ride_screen.dart';
import '../booking/sharing/sharing_ride_screen.dart';

class MyBookingsScreen extends StatelessWidget {
  MyBookingsScreen({super.key});

  final controller = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () {
            var count = controller.unreadCategoryCounts.value;
            return AppCustomTab(
              fontSize: 12.sp,
              selectedLabelColor: appColor.blackThemeColor,
              unSelectedLabelColor: appColor.whiteThemeColor,
              tabBackGroundColor: appColor.color353535,
              indicatorSelectedColor: appColor.greenThemeColor,
              indicatorUnSelectedColor: Colors.transparent,
              tabTitles: [
                'Sharing Ride',
                'Personal Ride',
                'Family Ride',
                "Drive's Availability",
                "Driver's Route",
                "Out Of Area"
              ],
              tabCounts: [
                count['totalSharingNotifications'] ?? 0,
                count['totalPersonalNotifications'] ?? 0,
                0,
                0,
                0,
                count['out_of_area']
              ],
              tabViews: [
                SharingRideScreen(),
                ComingSoon(),
                ComingSoon(),
                ComingSoon(),
                ComingSoon(),
                ComingSoon(),
              ],
              decoratedBoxRadius: 0,
              indicatorRadius: 5.r,
              onTabChange: (index) {
                handleTabSelection(index);
              },
            );
          },
        ),
      ),
    );
  }

  void handleTabSelection(int index) {
    String? categoryKey;

    switch (index) {
      case 0:
        categoryKey = "sharing";
        break;
      case 1:
        categoryKey = "personal";
        break;
      case 5:
        categoryKey = "out_of_area";
        break;
      default:
        categoryKey = null;
    }

    if (categoryKey != null) {
      controller.markCategoryAsRead(categoryKey);
    }
  }

}
