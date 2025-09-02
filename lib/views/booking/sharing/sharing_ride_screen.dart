import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mie_admin/utils/tabs/app_custom_tab.dart';
import '../../../controllers/root_controller.dart';
import '../../../utils/constants.dart';
import '../family/faimaly_ride_screen.dart';
import 'accepted/accepted_screen.dart';
import 'assigned/assigned_screen.dart';
import 'cancelled/cancelled_screen.dart';
import 'completed/completed_screen.dart';
import 'enroute/enroute_screen.dart';
import 'group/group_screen.dart';
import 'manual/manual_screen.dart';
import 'missed/missed_screen.dart';
import 'route/route_screen.dart';

class SharingRideScreen extends StatelessWidget {
  SharingRideScreen({super.key});

  final controller = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var count = controller.unreadCategoryCounts.value;
      return AppCustomTab(
        selectedLabelColor: appColor.whiteThemeColor,
        unSelectedLabelColor: appColor.blackThemeColor,
        tabBackGroundColor: appColor.greyThemeColor,
        indicatorSelectedColor: appColor.blackThemeColor,
        indicatorUnSelectedColor: appColor.greyDarkThemeColor,
        tabTitles: [
          'Analytics',
          'Upcoming Group',
          'Current Group',
          'Route',
          'Assigned',
          'Accepted',
          'Manual',
          'Missed',
          'Enroute',
          'Completed',
          'Cancelled',
        ],
        tabCounts: [
          count['sharing_analytics']??0,
          count['new_booking']??0,
          count['new_booking']??0,
          count['new_route_created']??0,
          count['sharing_assigned']??0,
          count['booking_accepted']??0,
          count['booking_manual']??0,
          count['booking_missed']??0,
          count['sharing_enroute']??0,
          count['booking_completed']??0,
          count['booking_canceled']??0,
        ],
        initialIndex: 2,
        tabViews: [
          ComingSoon(),
          GroupScreen(groupType: 'upcoming',),
          GroupScreen(groupType: 'current',),
          RouteScreen(),
          AssignedScreen(),
          AcceptedScreen(),
          ManualScreen(),
          MissedScreen(),
          EnrouteScreen(),
          CompletedScreen(),
          CancelledScreen(),
        ],
        decoratedBoxRadius: 0,
        indicatorRadius: 20.r,
        onTabChange: (index) {
          final categoryKeys = [
            'sharing_analytics',
            'new_booking',
            'new_booking',
            'new_route_created',
            'sharing_assigned',
            'booking_accepted',
            'booking_manual',
            'booking_missed',
            'sharing_enroute',
            'booking_completed',
            'booking_canceled',
          ];

          if (index < categoryKeys.length) {
            final category = categoryKeys[index];
            controller.markCategoryAsRead(category);
          }
        },
      );
    },);
  }
}
