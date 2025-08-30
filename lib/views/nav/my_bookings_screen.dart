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
        body: AppCustomTab(
          selectedLabelColor: appColor.blackThemeColor,
          unSelectedLabelColor: appColor.whiteThemeColor,
          tabBackGroundColor: appColor.blackThemeColor,
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
            controller.notificationData['totalSharingNotifications']??0,
            controller.notificationData['totalPersonalNotifications']??0,
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
        ),
      ),
    );
  }
}
